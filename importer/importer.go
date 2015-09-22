package main

import (
	"database/sql"
	"encoding/csv"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
	"regexp"
	"strconv"
	"strings"
	"time"

	"github.com/lib/pq"
)

var providerColumns = [...]string{
	"last_name_legal_name",
	"first_name",
	"middle_name",
	"name_prefix",
	"name_suffix",
	"other_last_name",
	"other_first_name",
	"other_middle_name",
	"other_name_prefix",
	"other_name_suffix",
	"other_last_name_type_code",
	"gender_code",
	"id"}

var providerHeaders = [...]string{
	"provider_last_name",
	"provider_first_name",
	"provider_middle_name",
	"provider_name_prefix",
	"provider_name_suffix",
	"provider_other_last_name",
	"provider_other_first_name",
	"provider_other_middle_name",
	"provider_other_name_prefix",
	"provider_other_name_suffix",
	"provider_other_last_name_type_code",
	"provider_gender_code"}

var organizationColumns = [...]string{
	"ein",
	"organization_name_legal_business_name",
	"other_organization_name",
	"other_organization_name_type_code",
	"authorized_official_last_name",
	"authorized_official_first_name",
	"authorized_official_middle_name",
	"authorized_official_name_prefix",
	"authorized_official_name_suffix",
	"authorized_official_credential",
	"authorized_official_titleor_position",
	"authorized_official_telephone_number",
	"is_organization_subpart",
	"parent_organization_lbn",
	"parent_organization_tin",
	"id"}

var organizationHeaders = [...]string{
	"employer_identification_number",
	"provider_organization_name",
	"provider_other_organization_name",
	"provider_other_organization_name_type_code",
	"authorized_official_last_name",
	"authorized_official_first_name",
	"authorized_official_middle_name",
	"authorized_official_name_prefix",
	"authorized_official_name_suffix",
	"authorized_official_credential",
	"authorized_official_titleor_position",
	"authorized_official_telephone_number",
	"is_organization_subpart",
	"parent_organization_lbn",
	"parent_organization_tin"}

var addressColumns = [...]string{
	"type", // mailing_address or practice_location_address
	"first_line",
	"second_line",
	"city",
	"state",
	"postal_code",
	"country_code",
	"telephone_number",
	"fax_number",
	"entity_type",
	"entity_id"}

var mailingHeaders = [...]string{
	"provider_first_line_business_mailing_address",
	"provider_second_line_business_mailing_address",
	"provider_business_mailing_address_city_name",
	"provider_business_mailing_address_state_name",
	"provider_business_mailing_address_postal_code",
	"provider_business_mailing_address_country_code",
	"provider_business_mailing_address_telephone_number",
	"provider_business_mailing_address_fax_number"}

var practiceLocationHeaders = [...]string{
	"provider_first_line_business_practice_location_address",
	"provider_second_line_business_practice_location_address",
	"provider_business_practice_location_address_city_name",
	"provider_business_practice_location_address_state_name",
	"provider_business_practice_location_address_postal_code",
	"provider_business_practice_location_address_country_code",
	"provider_business_practice_location_address_telephone_number",
	"provider_business_practice_location_address_fax_number"}

var otherProviderColumns = [...]string{
	"identifier",
	"identifier_type_code",
	"identifier_state",
	"identifier_issuer",
	"entity_type",
	"entity_id"}

var otherProviderHeaders = [...]string{"other_provider_identifier_%d",
	"other_provider_identifier_type_code_%d",
	"other_provider_identifier_state_%d",
	"other_provider_identifier_issuer_%d"}

var otherProviderNonNullIndicies = [...]int{0, 1, 2, 3}

var taxonomyLicenseColumns = [...]string{
	"code",
	"license_number",
	"license_number_state_code",
	"primary_taxonomy_switch",
	"entity_type",
	"entity_id"}

var taxonomyLicenseHeaders = [...]string{
	"healthcare_provider_taxonomy_code_%d",
	"provider_license_number_%d",
	"provider_license_number_state_code_%d",
	"healthcare_provider_primary_taxonomy_switch_%d"}

var taxonomyLicenseNullIndicies = [...]int{0, 1, 2, 3}

var taxonomyGroupColumns = [...]string{
	"taxonomy_group",
	"entity_type",
	"entity_id"}

var npiColumns = [...]string{
	"identifier",
	"entity_type",
	"entity_id"}

var npiHeaders = [...]string{
	"npi"}

var taxonomyGroupHeaders = [...]string{"healthcare_provider_taxonomy_group_%d"}
var taxonomyGroupNonNullIndicies = [...]int{0}

var updateFlag bool
var fileFlag string
var dbFlag string
var db *sql.DB

var (
	providerTable           = "providers"
	organizationTable       = "organizations"
	addressTable            = "addresses"
	providerIdentifierTable = "provider_identifiers"
	taxonomyLicenseTable    = "taxonomy_licenses"
	taxonomyGroupTable      = "taxonomy_groups"
)

func init() {
	flag.BoolVar(&updateFlag, "update", false, "process NPPES data as an update")
	flag.StringVar(&fileFlag, "file", "", "NPPES CSV file")
	flag.StringVar(&dbFlag, "db", "", "Destination database name")
	flag.Parse()

	db, _ = sql.Open("postgres", "dbname="+dbFlag+" sslmode=disable")

	if updateFlag {
		providerTable = "t_" + providerTable
		organizationTable = "t_" + organizationTable
		addressTable = "t_" + addressTable
		providerIdentifierTable = "t_" + providerIdentifierTable
		taxonomyLicenseTable = "t_" + taxonomyLicenseTable
		taxonomyGroupTable = "t_" + taxonomyGroupTable
		prepUpdate()
	}

}

func main() {
	err := db.Ping()
	logIfFatal(err)
	defer db.Close()

	if updateFlag {
		defer update()
	}

	startingTime := time.Now()
	fmt.Println("Started parsing", startingTime)

	csvfile, err := os.Open(fileFlag)
	logIfFatal(err)
	defer csvfile.Close()

	csvReader := csv.NewReader(csvfile)
	fmt.Println("reading csv parsing", time.Now())

	headers, err := csvReader.Read()
	for idx, header := range headers {
		headers[idx] = underscore(header)
	}
	logIfFatal(err)

	txns := make(map[string]*sql.Tx)
	copyIn := make(map[string]*sql.Stmt)
	copyIn["providers"], txns["providers"] = prepareCopyIn(providerTable, providerColumns[:], db)
	copyIn["organizations"], txns["organizations"] = prepareCopyIn(organizationTable, organizationColumns[:], db)
	copyIn["addresses"], txns["addresses"] = prepareCopyIn(addressTable, addressColumns[:], db)
	copyIn["provider_identifiers"], txns["provider_identifiers"] = prepareCopyIn(providerIdentifierTable, otherProviderColumns[:], db)
	copyIn["taxonomy_licenses"], txns["taxonomy_licenses"] = prepareCopyIn(taxonomyLicenseTable, taxonomyLicenseColumns[:], db)
	copyIn["taxonomy_groups"], txns["taxonomy_groups"] = prepareCopyIn(taxonomyGroupTable, taxonomyGroupColumns[:], db)
	copyIn["npi"], txns["npi"] = prepareCopyIn(providerIdentifierTable, npiColumns[:], db)

	for {

		record, err := csvReader.Read()

		if err != nil {
			if err == io.EOF {
				break
			}
			log.Fatalln(err)
		}

		recordMap := make(map[string]string)
		for idx, value := range record {
			if len(value) > 0 {
				recordMap[headers[idx]] = value
			}
		}

		insert(recordMap, copyIn)
	}

	for _, stmt := range copyIn {
		_, err = stmt.Exec() // flushes any buffered data
		logIfFatal(err)
		err = stmt.Close()
		logIfFatal(err)
	}
	for _, txn := range txns {
		err = txn.Commit()
		logIfFatal(err)
	}

	fmt.Println("Finished parsing", time.Now())

}

// helpers

func underscore(string string) string {
	parensRegexp := regexp.MustCompile(" \\(.*\\)")
	string = parensRegexp.ReplaceAllString(string, "")
	string = strings.ToLower(string)
	return strings.Replace(string, " ", "_", -1)
}

func fetchId(npi string, entityType string) int {
	var entityTypeStr string
	var seqName string
	var id int

	switch entityType {
	case "1":
		entityTypeStr = "Provider"
		seqName = "providers_id_seq"
		break
	case "2":
		entityTypeStr = "Organization"
		seqName = "organizations_id_seq"
		break
	}
	if entityTypeStr == "" {
		return 0
	}

	err := db.QueryRow("select case when exists (select entity_id from provider_identifiers where identifier = $1 and entity_type = $2) then (select entity_id from provider_identifiers where identifier = $1 and entity_type = $2) else nextval($3) end as entity_type;", npi, entityTypeStr, seqName).Scan(&id)
	if err != nil {
		log.Fatal(err)
	}
	return id
}

// notAllNull feels hacky, but should allow us to remove completely null values from the inserts
func insertData(headers []string, recordMap map[string]string, stmt *sql.Stmt, repeat int, ensureNonNull []int) {
	for i := 1; i <= repeat; i++ {
		var values []interface{}
		for _, header := range headers {
			if strings.Contains(header, "%d") {
				header = fmt.Sprintf(header, i)
			}
			value := recordMap[header]
			if len(value) > 0 {
				values = append(values, value)
			} else {
				values = append(values, nil)
			}
		}
		// if there should be at least one non-null in a group, check here
		if ensureNonNull != nil {
			oneNonNull := false
			for nonNullEntry := range ensureNonNull {
				if values[nonNullEntry] != nil {
					oneNonNull = true
					break
				}
			}
			if !oneNonNull {
				return
			}
		}

		values = append(values, recordMap["entity_id"])
		_, err := stmt.Exec(values...)
		if err != nil {
			fmt.Println(values)
			log.Fatal(err)
		}
	}
	//fmt.Println(values)
}

func insert(recordMap map[string]string, stmts map[string]*sql.Stmt) {
	/*
	if updateFlag {
		id, exists := checkForNpi(recordMap["npi"])
		if exists {
			recordMap["entity_id"] = strconv.Itoa(id)
		} else {
			recordMap["entity_id"] = fetchId(recordMap["entity_type_code"])
		}
	} else {
		recordMap["entity_id"] = fetchId(recordMap["entity_type_code"])
	}*/
	recordMap["entity_id"] = strconv.Itoa(fetchId(recordMap["npi"], recordMap["entity_type_code"]))

	if recordMap["entity_type_code"] == "1" {
		insertData(providerHeaders[:], recordMap, stmts["providers"], 1, nil)
		recordMap["entity_type"] = "Provider"
	} else if recordMap["entity_type_code"] == "2" {
		insertData(organizationHeaders[:], recordMap, stmts["organizations"], 1, nil)
		recordMap["entity_type"] = "Organization"
	} else if recordMap["entity_type_code"] == "" {
		// deactivated numbers
		if updateFlag {
			insertForDeletion(recordMap["npi"])
		}
		return
	} else {
		log.Fatal("Unknown entity type code")
	}

	recordMap["address_type"] = "MailingAddress"
	mailingHeaders := append([]string{"address_type"}, mailingHeaders[:]...) //prepend address_type
	mailingHeaders = append(mailingHeaders, "entity_type")                   // append entity_type
	insertData(mailingHeaders[:], recordMap, stmts["addresses"], 1, nil)

	recordMap["address_type"] = "PracticeLocationAddress"
	practiceLocationHeaders := append([]string{"address_type"}, practiceLocationHeaders[:]...)
	practiceLocationHeaders = append(practiceLocationHeaders, "entity_type")
	insertData(practiceLocationHeaders[:], recordMap, stmts["addresses"], 1, nil)

	otherProviderHeaders := append(otherProviderHeaders[:], "entity_type")
	insertData(otherProviderHeaders[:], recordMap, stmts["provider_identifiers"], 50, otherProviderNonNullIndicies[:])

	taxonomyLicenseHeaders := append(taxonomyLicenseHeaders[:], "entity_type")
	insertData(taxonomyLicenseHeaders[:], recordMap, stmts["taxonomy_licenses"], 15, taxonomyLicenseNullIndicies[:])

	taxonomyGroupHeaders := append(taxonomyGroupHeaders[:], "entity_type")
	insertData(taxonomyGroupHeaders[:], recordMap, stmts["taxonomy_groups"], 15, taxonomyGroupNonNullIndicies[:])

	npiHeaders := append(npiHeaders[:], "entity_type")
	insertData(npiHeaders[:], recordMap, stmts["npi"], 1, nil)

}

func prepareCopyIn(table string, columns []string, db *sql.DB) (*sql.Stmt, *sql.Tx) {
	txn, err := db.Begin()
	if err != nil {
		log.Fatal(err)
	}
	copyIn := pq.CopyIn(table, columns...)
	output, err := txn.Prepare(copyIn)
	if err != nil {
		fmt.Println(table)
		log.Fatal(err)
	}
	return output, txn
}

func logIfFatal(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func checkForNpi(npi string) (int, bool) {
	var entity_id int
	err := db.QueryRow("SELECT entity_id FROM provider_identifiers WHERE identifier = $1", npi).Scan(&entity_id)
	switch {
	case err == sql.ErrNoRows:
		return 0, false
	case err != nil:
		fmt.Println(npi)
		log.Fatal(err)
	}
	return entity_id, true
}

func insertForDeletion(npi string) {
	var err error
	var entityId int
	var entityType string

	err = db.QueryRow("SELECT entity_id, entity_type FROM provider_identifiers WHERE identifier = $1", npi).Scan(&entityId, &entityType)
	switch {
	case err == sql.ErrNoRows:
		return
	case err != nil:
		log.Fatal(err)
	}
	_, err = db.Exec("INSERT INTO t_deleted_npis (npi, entity_id, entity_type) VALUES ($1, $2, $3)", npi, entityId, entityType)
	logIfFatal(err)
}

func prepUpdate() {
	var err error
	_, err = db.Exec("CREATE TABLE IF NOT EXISTS t_providers ( LIKE providers INCLUDING ALL )")
	logIfFatal(err)

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS t_organizations ( LIKE organizations INCLUDING ALL )")
	logIfFatal(err)

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS t_addresses ( LIKE addresses INCLUDING ALL )")
	logIfFatal(err)

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS t_provider_identifiers ( LIKE provider_identifiers INCLUDING ALL )")
	logIfFatal(err)

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS t_taxonomy_licenses ( LIKE taxonomy_licenses INCLUDING ALL )")
	logIfFatal(err)

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS t_taxonomy_groups ( LIKE taxonomy_groups INCLUDING ALL )")
	logIfFatal(err)

	_, err = db.Exec("CREATE TABLE IF NOT EXISTS t_deleted_npis ( npi varchar, entity_id integer, entity_type varchar )")
	logIfFatal(err)
}

func update() {
	fmt.Println("running update...")
	var err error

	_, err = db.Exec(`UPDATE providers
										SET last_name_legal_name = t.last_name_legal_name,
										first_name = t.first_name,
										middle_name = t.middle_name,
										name_prefix = t.name_prefix,
										name_suffix = t.name_suffix,
										other_last_name = t.other_last_name,
										other_first_name = t.other_first_name,
										other_middle_name = t.other_middle_name,
										other_name_prefix = t.other_name_prefix,
										other_name_suffix = t.other_name_suffix,
										other_last_name_type_code = t.other_last_name_type_code,
										gender_code = t.gender_code
										from t_providers t
										where providers.id = t.id`)
	logIfFatal(err)
	_, err = db.Exec(`INSERT INTO providers
										(id, last_name_legal_name, first_name, middle_name, name_prefix, name_suffix, other_last_name, other_first_name, other_middle_name, other_name_prefix, other_name_suffix, other_last_name_type_code, gender_code)
										SELECT t.id,
														t.last_name_legal_name,
														t.first_name,
														t.middle_name,
														t.name_prefix,
														t.name_suffix,
														t.other_last_name,
														t.other_first_name,
														t.other_middle_name,
														t.other_name_prefix,
														t.other_name_suffix,
														t.other_last_name_type_code,
														t.gender_code
										FROM t_providers t
										LEFT OUTER JOIN providers ON (providers.id = t.id)
										WHERE providers.id IS NULL`)
	logIfFatal(err)

	_, err = db.Exec(`UPDATE organizations
										SET ein = t.ein,
										organization_name_legal_business_name = t.organization_name_legal_business_name,
										other_organization_name = t.other_organization_name,
										other_organization_name_type_code = t.other_organization_name_type_code,
										authorized_official_last_name = t.authorized_official_last_name,
										authorized_official_first_name = t.authorized_official_first_name,
										authorized_official_middle_name = t.authorized_official_middle_name,
										authorized_official_name_prefix = t.authorized_official_name_prefix,
										authorized_official_name_suffix = t.authorized_official_name_suffix,
										authorized_official_credential = t.authorized_official_credential,
										authorized_official_titleor_position = t.authorized_official_titleor_position,
										authorized_official_telephone_number = t.authorized_official_telephone_number,
										is_organization_subpart = t.is_organization_subpart,
										parent_organization_lbn = t.parent_organization_lbn,
										parent_organization_tin = t.parent_organization_tin
										FROM t_organizations t
										WHERE organizations.id = t.id`)
	logIfFatal(err)
	_, err = db.Exec(`INSERT INTO organizations
											(id,
											organization_name_legal_business_name,
											other_organization_name,
											other_organization_name_type_code,
											authorized_official_last_name,
											authorized_official_first_name,
											authorized_official_middle_name,
											authorized_official_name_prefix,
											authorized_official_name_suffix,
											authorized_official_credential,
											authorized_official_titleor_position,
											authorized_official_telephone_number,
											is_organization_subpart,
											parent_organization_lbn,
											parent_organization_tin)
										SELECT t.id,
											t.organization_name_legal_business_name,
											t.other_organization_name,
											t.other_organization_name_type_code,
											t.authorized_official_last_name,
											t.authorized_official_first_name,
											t.authorized_official_middle_name,
											t.authorized_official_name_prefix,
											t.authorized_official_name_suffix,
											t.authorized_official_credential,
											t.authorized_official_titleor_position,
											t.authorized_official_telephone_number,
											t.is_organization_subpart,
											t.parent_organization_lbn,
											t.parent_organization_tin
										FROM t_organizations t
										LEFT OUTER JOIN organizations ON (organizations.id = t.id)
										WHERE organizations.id IS NULL`)
	logIfFatal(err)

	_, err = db.Exec(`UPDATE addresses
										SET first_line = t.first_line,
										second_line = t.second_line,
										city = t.city,
										state = t.state,
										postal_code = t.postal_code,
										country_code = t.country_code,
										telephone_number = t.telephone_number,
										fax_number = t.fax_number
										FROM t_addresses t
										WHERE entity_id = t.entity_id AND entity_type = t.entity_type AND type = 'MailingAddress'`)
	logIfFatal(err)
	_, err = db.Exec(`UPDATE addresses
										SET first_line = t.first_line,
										second_line = t.second_line,
										city = t.city,
										state = t.state,
										postal_code = t.postal_code,
										country_code = t.country_code,
										telephone_number = t.telephone_number,
										fax_number = t.fax_number
										FROM t_addresses t
										WHERE entity_id = t.entity_id AND entity_type = t.entity_type AND type = 'PracticeLocationAddress'`)
	logIfFatal(err)
	_, err = db.Exec(`INSERT INTO addresses
										(id,
										type,
										first_line,
										second_line,
										city,
										state,
										postal_code,
										country_code,
										telephone_number
										fax_number,
										entity_id,
										entity_type)
									SELECT
										t.id,
										t.type,
										t.first_line,
										t.second_line,
										t.city,
										t.state,
										t.postal_code,
										t.country_code,
										t.telephone_number,
										t.fax_number,
										t.entity_id,
										t.entity_type
									FROM t_addresses t
									LEFT OUTER JOIN addresses on (entity_id = t.entity_id AND entity_type = t.entity_type)
									WHERE t.type = 'MailingAddress' AND entity_id IS NULL`)
	logIfFatal(err)
	_, err = db.Exec(`INSERT INTO addresses
										(id,
										type,
										first_line,
										second_line,
										city,
										state,
										postal_code,
										country_code,
										telephone_number
										fax_number,
										entity_id,
										entity_type)
									SELECT
										t.id,
										t.type,
										t.first_line,
										t.second_line,
										t.city,
										t.state,
										t.postal_code,
										t.country_code,
										t.telephone_number,
										t.fax_number,
										t.entity_id,
										t.entity_type
									FROM t_addresses t
									LEFT OUTER JOIN addresses on (entity_id = t.entity_id AND entity_type = t.entity_type)
									WHERE t.type = 'PracticeLocationAddress' AND entity_id IS NULL`)
	logIfFatal(err)

	_, err = db.Exec("DELETE FROM provider_identifiers WHERE entity_id IN (SELECT entity_id FROM t_provider_identifiers WHERE entity_type = 'Provider') AND entity_type = 'Provider'")
	logIfFatal(err)
	_, err = db.Exec("DELETE FROM provider_identifiers WHERE entity_id IN (SELECT entity_id FROM t_provider_identifiers WHERE entity_type = 'Organization') AND entity_type = 'Organization'")
	logIfFatal(err)
	_, err = db.Exec(`INSERT INTO provider_identifiers
										(identifier, identifier_type_code, identifier_state, identifier_issuer, entity_id, entity_type)
										SELECT
											t.identifier,
											t.identifier_type_code,
											t.identifier_state,
											t.identifier_issuer,
											t.entity_id,
											t.entity_type
										FROM t_provider_identifiers t`)
	logIfFatal(err)

	_, err = db.Exec("DELETE FROM taxonomy_licenses WHERE entity_id IN (SELECT entity_id FROM t_provider_identifiers WHERE entity_type = 'Provider') AND entity_type = 'Provider'")
	logIfFatal(err)
	_, err = db.Exec("DELETE FROM taxonomy_licenses WHERE entity_id IN (SELECT entity_id FROM t_provider_identifiers WHERE entity_type = 'Organization') AND entity_type = 'Organization'")
	logIfFatal(err)
	_, err = db.Exec(`INSERT INTO taxonomy_licenses
										(code, license_number, license_number_state_code, primary_taxonomy_switch, entity_id, entity_type)
										SELECT
											t.code,
											t.license_number,
											t.license_number_state_code,
											t.primary_taxonomy_switch,
											t.entity_id,
											t.entity_type
										FROM t_taxonomy_licenses t`)
	logIfFatal(err)

	_, err = db.Exec("DELETE FROM taxonomy_groups WHERE entity_id IN (SELECT entity_id FROM t_provider_identifiers WHERE entity_type = 'Provider') AND entity_type = 'Provider'")
	logIfFatal(err)
	_, err = db.Exec("DELETE FROM taxonomy_groups WHERE entity_id IN (SELECT entity_id FROM t_provider_identifiers WHERE entity_type = 'Organization') AND entity_type = 'Organization'")
	logIfFatal(err)
	_, err = db.Exec(`INSERT INTO taxonomy_groups
										(taxonomy_group, entity_id, entity_type)
										SELECT
											t.taxonomy_group,
											t.entity_id,
											t.entity_type
										FROM t_taxonomy_groups t`)
	logIfFatal(err)

	// deletions
	_, err = db.Exec(`DELETE FROM providers WHERE id IN (SELECT entity_id FROM t_deleted_npis WHERE entity_type = 'Provider')`)
	logIfFatal(err)

	_, err = db.Exec(`DELETE FROM organizations WHERE id IN (SELECT entity_id FROM t_deleted_npis WHERE entity_type = 'Organization')`)
	logIfFatal(err)

	_, err = db.Exec(`DELETE FROM addresses WHERE entity_id IN (SELECT entity_id FROM t_deleted_npis WHERE entity_type = 'Provider') AND entity_type = 'Provider'`)
	logIfFatal(err)
	_, err = db.Exec(`DELETE FROM addresses WHERE entity_id IN (SELECT entity_id FROM t_deleted_npis WHERE entity_type = 'Organization') AND entity_type = 'Organization'`)
	logIfFatal(err)

	_, err = db.Exec("DELETE FROM provider_identifiers WHERE entity_id IN (SELECT entity_id FROM t_deleted_npis WHERE entity_type = 'Provider') AND entity_type = 'Provider'")
	logIfFatal(err)
	_, err = db.Exec("DELETE FROM provider_identifiers WHERE entity_id IN (SELECT entity_id FROM t_deleted_npis WHERE entity_type = 'Organization') AND entity_type = 'Organization'")
	logIfFatal(err)

	_, err = db.Exec("DELETE FROM taxonomy_licenses WHERE entity_id IN (SELECT entity_id FROM t_deleted_npis WHERE entity_type = 'Provider') AND entity_type = 'Provider'")
	logIfFatal(err)
	_, err = db.Exec("DELETE FROM taxonomy_licenses WHERE entity_id IN (SELECT entity_id FROM t_deleted_npis WHERE entity_type = 'Organization') AND entity_type = 'Organization'")
	logIfFatal(err)

	_, err = db.Exec("DELETE FROM taxonomy_groups WHERE entity_id IN (SELECT entity_id FROM t_deleted_npis WHERE entity_type = 'Provider') AND entity_type = 'Provider'")
	logIfFatal(err)
	_, err = db.Exec("DELETE FROM taxonomy_groups WHERE entity_id IN (SELECT entity_id FROM t_deleted_npis WHERE entity_type = 'Organization') AND entity_type = 'Organization'")
	logIfFatal(err)

}

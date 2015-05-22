package main

import (
	"database/sql"
	"encoding/csv"
	"fmt"
	"github.com/lib/pq"
	"io"
	"log"
	"os"
	"regexp"
	"strings"
	"time"
)

var providerColumns = [...]string{
	"entity_type_code",
	"replacement_npi",
	"last_name_legal_name",
	"first_name",
	"middle_name",
	"name_prefix",
	"name_suffix",
	"credential",
	"other_last_name",
	"other_first_name",
	"other_middle_name",
	"other_name_prefix",
	"other_name_suffix",
	"other_credential",
	"other_last_name_type_code",
	"enumeration_date",
	"last_update_date",
	"npi_deactivation_reason_code",
	"npi_deactivation_date",
	"npi_reactivation_date",
	"gender_code",
	"is_sole_proprietor",
	"npi"}
var providerHeaders = [...]string{"entity_type_code", "replacement_npi",
	"provider_last_name", "provider_first_name",
	"provider_middle_name", "provider_name_prefix",
	"provider_name_suffix", "provider_credential",
	"provider_other_last_name", "provider_other_first_name",
	"provider_other_middle_name", "provider_other_name_prefix",
	"provider_other_name_suffix", "provider_other_credential",
	"provider_other_last_name_type_code", "provider_enumeration_date",
	"last_update_date", "npi_deactivation_reason_code",
	"npi_deactivation_date", "npi_reactivation_date",
	"provider_gender_code",
	"is_sole_proprietor"}

var organizationColumns = [...]string{
	"entity_type_code",
	"replacement_npi",
	"ein",
	"organization_name_legal_business_name",
	"other_organization_name",
	"other_organization_name_type_code",
	"enumeration_date",
	"last_update_date",
	"npi_deactivation_code",
	"npi_deactivation_date",
	"npi_reactivation_date",
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
	"npi"}
var organizationHeaders = [...]string{
	"entity_type_code",
	"replacement_npi",
	"employer_identification_number",
	"provider_organization_name",
	"provider_other_organization_name",
	"provider_other_organization_name_type_code",
	"provider_enumeration_date",
	"last_update_date",
	"npi_deactivation_reason_code",
	"npi_deactivation_date",
	"npi_reactivation_date",
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
var mailingHeaders = [...]string{"provider_first_line_business_mailing_address", "provider_second_line_business_mailing_address",
	"provider_business_mailing_address_city_name", "provider_business_mailing_address_state_name",
	"provider_business_mailing_address_postal_code", "provider_business_mailing_address_country_code",
	"provider_business_mailing_address_telephone_number", "provider_business_mailing_address_fax_number"}
var practiceLocationHeaders = [...]string{"provider_first_line_business_practice_location_address", "provider_second_line_business_practice_location_address",
	"provider_business_practice_location_address_city_name", "provider_business_practice_location_address_state_name",
	"provider_business_practice_location_address_postal_code", "provider_business_practice_location_address_country_code",
	"provider_business_practice_location_address_telephone_number", "provider_business_practice_location_address_fax_number"}

var otherProviderColumns = [...]string{
	"identifier",
	"identifier_type_code",
	"identifier_state",
	"identifier_issuer",
	"entity_type",
	"entity_id"}
var otherProviderHeaders = [...]string{"other_provider_identifier_%d", "other_provider_identifier_type_code_%d", "other_provider_identifier_state_%d", "other_provider_identifier_issuer_%d"}

var taxonomyLicenseColumns = [...]string{
	"taxonomy_code",
	"license_number",
	"license_number_state_code",
	"primary_taxonomy_switch",
	"entity_type",
	"entity_id"}
var taxonomyLicenseHeaders = [...]string{"healthcare_provider_taxonomy_code_%d", "provider_license_number_%d", "provider_license_number_state_code_%d", "healthcare_provider_primary_taxonomy_switch_%d"}

var taxonomyGroupColumns = [...]string{
	"taxonomy_group",
	"entity_type",
	"entity_id"}
var taxonomyGroupHeaders = [...]string{"healthcare_provider_taxonomy_group_%d"}

func underscore(string string) string {
	parensRegexp := regexp.MustCompile(" \\(.*\\)")
	string = parensRegexp.ReplaceAllString(string, "")
	string = strings.ToLower(string)
	return strings.Replace(string, " ", "_", -1)
}

// notAllNull feels hacky, but should allow us to remove completely null values from the inserts
func insertData(headers []string, recordMap map[string]string, stmt *sql.Stmt, repeat int) {
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
		values = append(values, recordMap["npi"])
		_, err := stmt.Exec(values...)
		if err != nil {
			fmt.Println(values)
			log.Fatal(err)
		}
	}
	//fmt.Println(values)
}

func insert(recordMap map[string]string, stmts map[string]*sql.Stmt) {
	if recordMap["entity_type_code"] == "1" {
		insertData(providerHeaders[:], recordMap, stmts["providers"], 1)
		recordMap["entity_type"] = "Provider"
	} else if recordMap["entity_type_code"] == "2" {
		insertData(organizationHeaders[:], recordMap, stmts["organizations"], 1)
		recordMap["entity_type"] = "Organization"
	} else if recordMap["entity_type_code"] == "" {
	} else {
		log.Fatal("Unknown entity type code")
	}

	recordMap["address_type"] = "MailingAddress"
	mailingHeaders := append([]string{"address_type"}, mailingHeaders[:]...) //prepend address_type
	mailingHeaders = append(mailingHeaders, "entity_type")                   // append entity_type
	insertData(mailingHeaders[:], recordMap, stmts["addresses"], 1)

	recordMap["address_type"] = "PracticeLocationAddress"
	practiceLocationHeaders := append([]string{"address_type"}, practiceLocationHeaders[:]...)
	practiceLocationHeaders = append(practiceLocationHeaders, "entity_type")
	insertData(practiceLocationHeaders[:], recordMap, stmts["addresses"], 1)

	otherProviderHeaders := append(otherProviderHeaders[:], "entity_type")
	insertData(otherProviderHeaders[:], recordMap, stmts["other_provider_identifiers"], 50)

	taxonomyGroupHeaders := append(taxonomyGroupHeaders[:], "entity_type")
	insertData(taxonomyGroupHeaders[:], recordMap, stmts["taxonomy_groups"], 15)

	taxonomyLicenseHeaders := append(taxonomyLicenseHeaders[:], "entity_type")
	insertData(taxonomyLicenseHeaders[:], recordMap, stmts["taxonomy_licenses"], 15)

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

func main() {

	startingTime := time.Now()
	fmt.Println("Started parsing", startingTime)

	csvfile, err := os.Open(os.Args[2])
	if err != nil {
		log.Fatal(err)
	}
	defer csvfile.Close()

	csvReader := csv.NewReader(csvfile)
	fmt.Println("reading csv parsing", time.Now())

	headers, err := csvReader.Read()
	for idx, header := range headers {
		headers[idx] = underscore(header)
	}
	if err != nil {
		log.Fatal(err)
	}

	db, err := sql.Open("postgres", " dbname="+os.Args[1]+" sslmode=disable")
	txns := make(map[string]*sql.Tx)
	copyIn := make(map[string]*sql.Stmt)
	copyIn["providers"], txns["providers"] = prepareCopyIn("providers", providerColumns[:], db)
	copyIn["organizations"], txns["organizations"] = prepareCopyIn("organizations", organizationColumns[:], db)
	copyIn["addresses"], txns["addresses"] = prepareCopyIn("addresses", addressColumns[:], db)
	copyIn["other_provider_identifiers"], txns["other_provider_identifiers"] = prepareCopyIn("other_provider_identifiers", otherProviderColumns[:], db)
	copyIn["taxonomy_licenses"], txns["taxonomy_licenses"] = prepareCopyIn("taxonomy_licenses", taxonomyLicenseColumns[:], db)
	copyIn["taxonomy_groups"], txns["taxonomy_groups"] = prepareCopyIn("taxonomy_groups", taxonomyGroupColumns[:], db)

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
		err = stmt.Close()
		if err != nil {
			log.Fatal(err)
		}
	}
	for _, txn := range txns {
		err = txn.Commit()
		if err != nil {
			log.Fatal(err)
		}
	}

	fmt.Println("Finished parsing", time.Now())
}

package main

import (
	"database/sql"
	"encoding/csv"
	"fmt"
	_ "github.com/lib/pq"
	"io"
	"log"
	"os"
	"regexp"
	"strings"
	"time"
)

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

var organizationHeaders = [...]string{"npi", "entity_type_code", "replacement_npi",
	"employer_identification_number", "provider_organization_name",
	"provider_other_organization_name", "provider_other_organization_name_type_code",
	"provider_enumeration_date",
	"last_update_date", "npi_deactivation_reason_code",
	"npi_deactivation_date", "npi_reactivation_date", "authorized_official_last_name",
	"authorized_official_first_name", "authorized_official_middle_name",
	"authorized_official_name_prefix", "authorized_official_name_suffix",
	"authorized_official_credential",
	"authorized_official_titleor_position", "authorized_official_telephone_number",
	"is_organization_subpart",
	"parent_organization_lbn", "parent_organization_tin"}

var mailingHeaders = [...]string{"provider_first_line_business_mailing_address", "provider_second_line_business_mailing_address",
	"provider_business_mailing_address_city_name", "provider_business_mailing_address_state_name",
	"provider_business_mailing_address_postal_code", "provider_business_mailing_address_country_code",
	"provider_business_mailing_address_telephone_number", "provider_business_mailing_address_fax_number"}

var practiceLocationHeaders = [...]string{"provider_first_line_business_practice_location_address", "provider_second_line_business_practice_location_address",
	"provider_business_practice_location_address_city_name", "provider_business_practice_location_address_state_name",
	"provider_business_practice_location_address_postal_code", "provider_business_practice_location_address_country_code",
	"provider_business_practice_location_address_telephone_number", "provider_business_practice_location_address_fax_number"}

var otherProviderHeaders = [...]string{"other_provider_identifier_%d", "other_provider_identifier_type_code_%d", "other_provider_identifier_state_%d", "other_provider_identifier_issuer_%d"}

var taxonomyLicenseHeaders = [...]string{"healthcare_provider_taxonomy_code_%d", "provider_license_number_%d", "provider_license_number_state_code_%d", "healthcare_provider_primary_taxonomy_switch_%d"}

var taxonomyGroupHeaders = [...]string{"healthcare_provider_taxonomy_group_%d"}

func nullEmptyCheck(val string) string {
	output := strings.Replace(val, "'", "''", -1)
	if output == "" {
		return "DEFAULT"
	}
	return "'" + output + "'"
}
func createInsert(csvIndicies []string, record []string, nppesHeaders map[string]int, reportNull bool) string {
	output := ""
	nonNullCount := 0
	for index, element := range csvIndicies {
		ending := ","
		if index == len(csvIndicies)-1 {
			ending = ""
		}
		deafultCheck := nullEmptyCheck(record[nppesHeaders[element]])
		if deafultCheck == "DEFAULT" {
			nonNullCount = nonNullCount + 1
		}
		output = output + deafultCheck + ending
	}
	if nonNullCount == len(csvIndicies)-1 && reportNull {
		output = ""
	}
	return output
}

func underscore(string string) string {
	parensRegexp := regexp.MustCompile(" \\(.*\\)")
	string = parensRegexp.ReplaceAllString(string, "")
	string = strings.ToLower(string)
	return strings.Replace(string, " ", "_", -1)
}

func insertData(headers []string, recordMap map[string]string) {
	var values []string
	for _, header := range headers {
		values = append(values, recordMap[header])
	}
	fmt.Println(values)
}

func insert(recordMap map[string]string) {
	if recordMap["entity_type_code"] == "1" {
		insertData(providerHeaders[:], recordMap)
	} else if recordMap["entity_type_code"] == "2" {
		insertData(organizationHeaders[:], recordMap)
	} else if recordMap["entity_type_code"] == "" {
	} else {
		log.Fatal("Unknown entity type code")
	}
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

		insert(recordMap)
	}

	db, err := sql.Open("postgres", " dbname="+os.Args[1]+" sslmode=disable")
	if err != nil {
		log.Fatal(err)
	}
	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Finished parsing", time.Now())
}

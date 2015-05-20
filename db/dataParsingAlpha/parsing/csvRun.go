package main

import (
	"database/sql"
	"encoding/csv"
	"fmt"
	_ "github.com/lib/pq"
	"io"
	"log"
	"os"
	"strings"
	"time"
)

func keyMap() map[string]int {
	return map[string]int{
		"npi":              0,
		"entity_type_code": 1,
		"replacement_npi":  2,
		"ein":              3,
		"provider_organization_name_legal_business_name":                         4,
		"provider_last_name_legal_name":                                          5,
		"provider_first_name":                                                    6,
		"provider_middle_name":                                                   7,
		"provider_name_prefix":                                                   8,
		"provider_name_suffix":                                                   9,
		"provider_credential":                                                    10,
		"provider_other_organization_name":                                       11,
		"provider_other_organization_name_type_code":                             12,
		"provider_other_last_name":                                               13,
		"provider_other_first_name":                                              14,
		"provider_other_middle_name":                                             15,
		"provider_other_name_prefix":                                             16,
		"provider_other_name_suffix":                                             17,
		"provider_other_credential":                                              18,
		"provider_other_last_name_type_code":                                     19,
		"provider_first_line_business_mailing_address":                           20,
		"provider_second_line_business_mailing_address":                          21,
		"provider_business_mailing_address_city_name":                            22,
		"provider_business_mailing_address_state_name":                           23,
		"provider_business_mailing_address_postal_code":                          24,
		"provider_business_mailing_address_country_code_if_outside_us":           25,
		"provider_business_mailing_address_telephone_number":                     26,
		"provider_business_mailing_address_fax_number":                           27,
		"provider_first_line_business_practice_location_address":                 28,
		"provider_second_line_business_practice_location_address":                29,
		"provider_business_practice_location_address_city_name":                  30,
		"provider_business_practice_location_address_state_name":                 31,
		"provider_business_practice_location_address_postal_code":                32,
		"provider_business_practice_location_address_country_code_if_outside_us": 33,
		"provider_business_practice_location_address_telephone_number":           34,
		"provider_business_practice_location_address_fax_number":                 35,
		"provider_enumeration_date":                                              36,
		"last_update_date":                                                       37,
		"npi_deactivation_reason_code":                                           38,
		"npi_deactivation_date":                                                  39,
		"npi_reactivation_date":                                                  40,
		"provider_gender_code":                                                   41,
		"authorized_official_last_name":                                          42,
		"authorized_official_first_name":                                         43,
		"authorized_official_middle_name":                                        44,
		"authorized_official_titleor_position":                                   45,
		"authorized_official_telephone_number":                                   46,
		"healthcare_provider_taxonomy_code_1":                                    47,
		"provider_license_number_1":                                              48,
		"provider_license_number_state_code_1":                                   49,
		"healthcare_provider_primary_taxonomy_switch_1":                          50,
		"healthcare_provider_taxonomy_code_2":                                    51,
		"provider_license_number_2":                                              52,
		"provider_license_number_state_code_2":                                   53,
		"healthcare_provider_primary_taxonomy_switch_2":                          54,
		"healthcare_provider_taxonomy_code_3":                                    55,
		"provider_license_number_3":                                              56,
		"provider_license_number_state_code_3":                                   57,
		"healthcare_provider_primary_taxonomy_switch_3":                          58,
		"healthcare_provider_taxonomy_code_4":                                    59,
		"provider_license_number_4":                                              60,
		"provider_license_number_state_code_4":                                   61,
		"healthcare_provider_primary_taxonomy_switch_4":                          62,
		"healthcare_provider_taxonomy_code_5":                                    63,
		"provider_license_number_5":                                              64,
		"provider_license_number_state_code_5":                                   65,
		"healthcare_provider_primary_taxonomy_switch_5":                          66,
		"healthcare_provider_taxonomy_code_6":                                    67,
		"provider_license_number_6":                                              68,
		"provider_license_number_state_code_6":                                   69,
		"healthcare_provider_primary_taxonomy_switch_6":                          70,
		"healthcare_provider_taxonomy_code_7":                                    71,
		"provider_license_number_7":                                              72,
		"provider_license_number_state_code_7":                                   73,
		"healthcare_provider_primary_taxonomy_switch_7":                          74,
		"healthcare_provider_taxonomy_code_8":                                    75,
		"provider_license_number_8":                                              76,
		"provider_license_number_state_code_8":                                   77,
		"healthcare_provider_primary_taxonomy_switch_8":                          78,
		"healthcare_provider_taxonomy_code_9":                                    79,
		"provider_license_number_9":                                              80,
		"provider_license_number_state_code_9":                                   81,
		"healthcare_provider_primary_taxonomy_switch_9":                          82,
		"healthcare_provider_taxonomy_code_10":                                   83,
		"provider_license_number_10":                                             84,
		"provider_license_number_state_code_10":                                  85,
		"healthcare_provider_primary_taxonomy_switch_10":                         86,
		"healthcare_provider_taxonomy_code_11":                                   87,
		"provider_license_number_11":                                             88,
		"provider_license_number_state_code_11":                                  89,
		"healthcare_provider_primary_taxonomy_switch_11":                         90,
		"healthcare_provider_taxonomy_code_12":                                   91,
		"provider_license_number_12":                                             92,
		"provider_license_number_state_code_12":                                  93,
		"healthcare_provider_primary_taxonomy_switch_12":                         94,
		"healthcare_provider_taxonomy_code_13":                                   95,
		"provider_license_number_13":                                             96,
		"provider_license_number_state_code_13":                                  97,
		"healthcare_provider_primary_taxonomy_switch_13":                         98,
		"healthcare_provider_taxonomy_code_14":                                   99,
		"provider_license_number_14":                                             100,
		"provider_license_number_state_code_14":                                  101,
		"healthcare_provider_primary_taxonomy_switch_14":                         102,
		"healthcare_provider_taxonomy_code_15":                                   103,
		"provider_license_number_15":                                             104,
		"provider_license_number_state_code_15":                                  105,
		"healthcare_provider_primary_taxonomy_switch_15":                         106,
		"other_provider_identifier_1":                                            107,
		"other_provider_identifier_type_code_1":                                  108,
		"other_provider_identifier_state_1":                                      109,
		"other_provider_identifier_issuer_1":                                     110,
		"other_provider_identifier_2":                                            111,
		"other_provider_identifier_type_code_2":                                  112,
		"other_provider_identifier_state_2":                                      113,
		"other_provider_identifier_issuer_2":                                     114,
		"other_provider_identifier_3":                                            115,
		"other_provider_identifier_type_code_3":                                  116,
		"other_provider_identifier_state_3":                                      117,
		"other_provider_identifier_issuer_3":                                     118,
		"other_provider_identifier_4":                                            119,
		"other_provider_identifier_type_code_4":                                  120,
		"other_provider_identifier_state_4":                                      121,
		"other_provider_identifier_issuer_4":                                     122,
		"other_provider_identifier_5":                                            123,
		"other_provider_identifier_type_code_5":                                  124,
		"other_provider_identifier_state_5":                                      125,
		"other_provider_identifier_issuer_5":                                     126,
		"other_provider_identifier_6":                                            127,
		"other_provider_identifier_type_code_6":                                  128,
		"other_provider_identifier_state_6":                                      129,
		"other_provider_identifier_issuer_6":                                     130,
		"other_provider_identifier_7":                                            131,
		"other_provider_identifier_type_code_7":                                  132,
		"other_provider_identifier_state_7":                                      133,
		"other_provider_identifier_issuer_7":                                     134,
		"other_provider_identifier_8":                                            135,
		"other_provider_identifier_type_code_8":                                  136,
		"other_provider_identifier_state_8":                                      137,
		"other_provider_identifier_issuer_8":                                     138,
		"other_provider_identifier_9":                                            139,
		"other_provider_identifier_type_code_9":                                  140,
		"other_provider_identifier_state_9":                                      141,
		"other_provider_identifier_issuer_9":                                     142,
		"other_provider_identifier_10":                                           143,
		"other_provider_identifier_type_code_10":                                 144,
		"other_provider_identifier_state_10":                                     145,
		"other_provider_identifier_issuer_10":                                    146,
		"other_provider_identifier_11":                                           147,
		"other_provider_identifier_type_code_11":                                 148,
		"other_provider_identifier_state_11":                                     149,
		"other_provider_identifier_issuer_11":                                    150,
		"other_provider_identifier_12":                                           151,
		"other_provider_identifier_type_code_12":                                 152,
		"other_provider_identifier_state_12":                                     153,
		"other_provider_identifier_issuer_12":                                    154,
		"other_provider_identifier_13":                                           155,
		"other_provider_identifier_type_code_13":                                 156,
		"other_provider_identifier_state_13":                                     157,
		"other_provider_identifier_issuer_13":                                    158,
		"other_provider_identifier_14":                                           159,
		"other_provider_identifier_type_code_14":                                 160,
		"other_provider_identifier_state_14":                                     161,
		"other_provider_identifier_issuer_14":                                    162,
		"other_provider_identifier_15":                                           163,
		"other_provider_identifier_type_code_15":                                 164,
		"other_provider_identifier_state_15":                                     165,
		"other_provider_identifier_issuer_15":                                    166,
		"other_provider_identifier_16":                                           167,
		"other_provider_identifier_type_code_16":                                 168,
		"other_provider_identifier_state_16":                                     169,
		"other_provider_identifier_issuer_16":                                    170,
		"other_provider_identifier_17":                                           171,
		"other_provider_identifier_type_code_17":                                 172,
		"other_provider_identifier_state_17":                                     173,
		"other_provider_identifier_issuer_17":                                    174,
		"other_provider_identifier_18":                                           175,
		"other_provider_identifier_type_code_18":                                 176,
		"other_provider_identifier_state_18":                                     177,
		"other_provider_identifier_issuer_18":                                    178,
		"other_provider_identifier_19":                                           179,
		"other_provider_identifier_type_code_19":                                 180,
		"other_provider_identifier_state_19":                                     181,
		"other_provider_identifier_issuer_19":                                    182,
		"other_provider_identifier_20":                                           183,
		"other_provider_identifier_type_code_20":                                 184,
		"other_provider_identifier_state_20":                                     185,
		"other_provider_identifier_issuer_20":                                    186,
		"other_provider_identifier_21":                                           187,
		"other_provider_identifier_type_code_21":                                 188,
		"other_provider_identifier_state_21":                                     189,
		"other_provider_identifier_issuer_21":                                    190,
		"other_provider_identifier_22":                                           191,
		"other_provider_identifier_type_code_22":                                 192,
		"other_provider_identifier_state_22":                                     193,
		"other_provider_identifier_issuer_22":                                    194,
		"other_provider_identifier_23":                                           195,
		"other_provider_identifier_type_code_23":                                 196,
		"other_provider_identifier_state_23":                                     197,
		"other_provider_identifier_issuer_23":                                    198,
		"other_provider_identifier_24":                                           199,
		"other_provider_identifier_type_code_24":                                 200,
		"other_provider_identifier_state_24":                                     201,
		"other_provider_identifier_issuer_24":                                    202,
		"other_provider_identifier_25":                                           203,
		"other_provider_identifier_type_code_25":                                 204,
		"other_provider_identifier_state_25":                                     205,
		"other_provider_identifier_issuer_25":                                    206,
		"other_provider_identifier_26":                                           207,
		"other_provider_identifier_type_code_26":                                 208,
		"other_provider_identifier_state_26":                                     209,
		"other_provider_identifier_issuer_26":                                    210,
		"other_provider_identifier_27":                                           211,
		"other_provider_identifier_type_code_27":                                 212,
		"other_provider_identifier_state_27":                                     213,
		"other_provider_identifier_issuer_27":                                    214,
		"other_provider_identifier_28":                                           215,
		"other_provider_identifier_type_code_28":                                 216,
		"other_provider_identifier_state_28":                                     217,
		"other_provider_identifier_issuer_28":                                    218,
		"other_provider_identifier_29":                                           219,
		"other_provider_identifier_type_code_29":                                 220,
		"other_provider_identifier_state_29":                                     221,
		"other_provider_identifier_issuer_29":                                    222,
		"other_provider_identifier_30":                                           223,
		"other_provider_identifier_type_code_30":                                 224,
		"other_provider_identifier_state_30":                                     225,
		"other_provider_identifier_issuer_30":                                    226,
		"other_provider_identifier_31":                                           227,
		"other_provider_identifier_type_code_31":                                 228,
		"other_provider_identifier_state_31":                                     229,
		"other_provider_identifier_issuer_31":                                    230,
		"other_provider_identifier_32":                                           231,
		"other_provider_identifier_type_code_32":                                 232,
		"other_provider_identifier_state_32":                                     233,
		"other_provider_identifier_issuer_32":                                    234,
		"other_provider_identifier_33":                                           235,
		"other_provider_identifier_type_code_33":                                 236,
		"other_provider_identifier_state_33":                                     237,
		"other_provider_identifier_issuer_33":                                    238,
		"other_provider_identifier_34":                                           239,
		"other_provider_identifier_type_code_34":                                 240,
		"other_provider_identifier_state_34":                                     241,
		"other_provider_identifier_issuer_34":                                    242,
		"other_provider_identifier_35":                                           243,
		"other_provider_identifier_type_code_35":                                 244,
		"other_provider_identifier_state_35":                                     245,
		"other_provider_identifier_issuer_35":                                    246,
		"other_provider_identifier_36":                                           247,
		"other_provider_identifier_type_code_36":                                 248,
		"other_provider_identifier_state_36":                                     249,
		"other_provider_identifier_issuer_36":                                    250,
		"other_provider_identifier_37":                                           251,
		"other_provider_identifier_type_code_37":                                 252,
		"other_provider_identifier_state_37":                                     253,
		"other_provider_identifier_issuer_37":                                    254,
		"other_provider_identifier_38":                                           255,
		"other_provider_identifier_type_code_38":                                 256,
		"other_provider_identifier_state_38":                                     257,
		"other_provider_identifier_issuer_38":                                    258,
		"other_provider_identifier_39":                                           259,
		"other_provider_identifier_type_code_39":                                 260,
		"other_provider_identifier_state_39":                                     261,
		"other_provider_identifier_issuer_39":                                    262,
		"other_provider_identifier_40":                                           263,
		"other_provider_identifier_type_code_40":                                 264,
		"other_provider_identifier_state_40":                                     265,
		"other_provider_identifier_issuer_40":                                    266,
		"other_provider_identifier_41":                                           267,
		"other_provider_identifier_type_code_41":                                 268,
		"other_provider_identifier_state_41":                                     269,
		"other_provider_identifier_issuer_41":                                    270,
		"other_provider_identifier_42":                                           271,
		"other_provider_identifier_type_code_42":                                 272,
		"other_provider_identifier_state_42":                                     273,
		"other_provider_identifier_issuer_42":                                    274,
		"other_provider_identifier_43":                                           275,
		"other_provider_identifier_type_code_43":                                 276,
		"other_provider_identifier_state_43":                                     277,
		"other_provider_identifier_issuer_43":                                    278,
		"other_provider_identifier_44":                                           279,
		"other_provider_identifier_type_code_44":                                 280,
		"other_provider_identifier_state_44":                                     281,
		"other_provider_identifier_issuer_44":                                    282,
		"other_provider_identifier_45":                                           283,
		"other_provider_identifier_type_code_45":                                 284,
		"other_provider_identifier_state_45":                                     285,
		"other_provider_identifier_issuer_45":                                    286,
		"other_provider_identifier_46":                                           287,
		"other_provider_identifier_type_code_46":                                 288,
		"other_provider_identifier_state_46":                                     289,
		"other_provider_identifier_issuer_46":                                    290,
		"other_provider_identifier_47":                                           291,
		"other_provider_identifier_type_code_47":                                 292,
		"other_provider_identifier_state_47":                                     293,
		"other_provider_identifier_issuer_47":                                    294,
		"other_provider_identifier_48":                                           295,
		"other_provider_identifier_type_code_48":                                 296,
		"other_provider_identifier_state_48":                                     297,
		"other_provider_identifier_issuer_48":                                    298,
		"other_provider_identifier_49":                                           299,
		"other_provider_identifier_type_code_49":                                 300,
		"other_provider_identifier_state_49":                                     301,
		"other_provider_identifier_issuer_49":                                    302,
		"other_provider_identifier_50":                                           303,
		"other_provider_identifier_type_code_50":                                 304,
		"other_provider_identifier_state_50":                                     305,
		"other_provider_identifier_issuer_50":                                    306,
		"is_sole_proprietor":                                                     307,
		"is_organization_subpart":                                                308,
		"parent_organization_lbn":                                                309,
		"parent_organization_tin":                                                310,
		"authorized_official_name_prefix":                                        311,
		"authorized_official_name_suffix":                                        312,
		"authorized_official_credential":                                         313,
		"healthcare_provider_taxonomy_group_1":                                   314,
		"healthcare_provider_taxonomy_group_2":                                   315,
		"healthcare_provider_taxonomy_group_3":                                   316,
		"healthcare_provider_taxonomy_group_4":                                   317,
		"healthcare_provider_taxonomy_group_5":                                   318,
		"healthcare_provider_taxonomy_group_6":                                   319,
		"healthcare_provider_taxonomy_group_7":                                   320,
		"healthcare_provider_taxonomy_group_8":                                   321,
		"healthcare_provider_taxonomy_group_9":                                   322,
		"healthcare_provider_taxonomy_group_10":                                  323,
		"healthcare_provider_taxonomy_group_11":                                  324,
		"healthcare_provider_taxonomy_group_12":                                  325,
		"healthcare_provider_taxonomy_group_13":                                  326,
		"healthcare_provider_taxonomy_group_14":                                  327,
		"healthcare_provider_taxonomy_group_15":                                  328,
	}
}
func dbSetup(db *sql.DB) {

	createProvider := `CREATE TABLE IF NOT EXISTS provider (
	  npi bigint PRIMARY KEY,
	  entity_type_code int,
	  replacement_npi bigint,
	  ein varchar,
	  provider_organization_name_legal_business_name varchar,
	  provider_last_name_legal_name varchar,
	  provider_first_name varchar,
	  provider_middle_name varchar,
	  provider_name_prefix varchar,
	  provider_name_suffix varchar,
	  provider_credential varchar,
	  provider_other_organization_name varchar,
	  provider_other_organization_name_type_code varchar,
	  provider_other_last_name varchar,
	  provider_other_first_name varchar,
	  provider_other_middle_name varchar,
	  provider_other_name_prefix varchar,
	  provider_other_name_suffix varchar,
	  provider_other_credential varchar,
	  provider_other_last_name_type_code bigint,
	  provider_enumeration_date date,
	  last_update_date date,
	  npi_deactivation_reason_code varchar,
	  npi_deactivation_date date,
	  npi_reactivation_date date,
	  provider_gender_code varchar,
	  authorized_official_last_name varchar,
	  authorized_official_first_name varchar,
	  authorized_official_middle_name varchar,
	  authorized_official_titleor_position varchar,
	  authorized_official_telephone_number varchar,
	  is_sole_proprietor varchar,
	  is_organization_subpart varchar,
	  parent_organization_lbn varchar,
	  parent_organization_tin varchar,
	  authorized_official_name_prefix varchar,
	  authorized_official_name_suffix varchar,
	  authorized_official_credential varchar
	);`

	createAddress := `CREATE TABLE IF NOT EXISTS address (
	  type VARCHAR,
	  first_line VARCHAR,
	  second_line VARCHAR,
	  city_name VARCHAR,
	  state_name VARCHAR,
	  postal_code VARCHAR,
	  country_code VARCHAR,
	  telephone_number VARCHAR,
	  fax_number VARCHAR,
	  npi_fk bigint references provider(npi)
	);`

	createHealthcareProviderTaxonomyGroup := `CREATE TABLE IF NOT EXISTS healthcare_provider_taxonomy_group (
	  taxonomy_group varchar,
	  npi_fk bigint references provider(npi)
	);`

	createOtherProvider := `CREATE TABLE IF NOT EXISTS other_provider (
	  other_provider_identifier varchar,
	  other_provider_identifier_type_code varchar,
	  other_provider_identifier_state varchar,
	  other_provider_identifier_issuer varchar,
	  npi_fk bigint references provider(npi)
	);`

	createTaxonomyTable := `CREATE TABLE IF NOT EXISTS taxonomy_license (
	  healthcare_provider_taxonomy_code varchar,
	  provider_license_number varchar,
	  provider_license_number_state_code varchar,
	  healthcare_provider_primary_taxonomy_switch varchar,
	  npi_fk bigint references provider(npi)
	);`

	_, err = db.Exec("DROP TABLE IF EXISTS address")
	if err != nil {
		log.Fatalln(err)
	}
	db.Exec("DROP TABLE IF EXISTS healthcare_provider_taxonomy_group")
	db.Exec("DROP TABLE IF EXISTS other_provider")
	db.Exec("DROP TABLE IF EXISTS taxonomy_license")
	db.Exec("DROP TABLE IF EXISTS provider")

	db.Exec(createProvider)
	db.Exec(createAddress)
	db.Exec(createHealthcareProviderTaxonomyGroup)
	db.Exec(createOtherProvider)
	db.Exec(createTaxonomyTable)

	return db
}

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

func main() {
	argsWithoutProg := os.Args[1:]
	startingTime := time.Now()
	fmt.Println("Started parsing", startingTime)
	csvfile, err := os.Open(argsWithoutProg[1])

	defer csvfile.Close()

	if err != nil {
		fmt.Println(err)
		os.Exit(1)
	}
	first := true
	nppesHeaders := keyMap()

	db, err := sql.Open("postgres", " dbname="+argsWithoutProg[0]+" sslmode=disable")
	if err != nil {
		log.Fatal(err)
	}
	dbSetup(db)
	err = db.Ping()

	csvReader := csv.NewReader(csvfile)
	fmt.Println("reading csv parsing", time.Now())
	i := int64(0)
	output := ""
	for {
		record, err := csvReader.Read()
		if first {
			first = false
			continue
		}
		if err != nil {
			if err == io.EOF {
				break
			}
			log.Fatalln(err)
		}

		insertProvider := "INSERT INTO provider VALUES ("
		insertAddress := "INSERT INTO address VALUES ("
		insertHealthcareProviderTaxonomyGroup := "INSERT INTO healthcare_provider_taxonomy_group VALUES ("
		insertOtherProvider := "INSERT INTO other_provider VALUES ("
		insertTaxonomyTable := "INSERT INTO taxonomy_license VALUES ("

		providerHeaders := [...]string{"npi", "entity_type_code", "replacement_npi",
			"ein", "provider_organization_name_legal_business_name",
			"provider_last_name_legal_name", "provider_first_name",
			"provider_middle_name", "provider_name_prefix",
			"provider_name_suffix", "provider_credential",
			"provider_other_organization_name", "provider_other_organization_name_type_code",
			"provider_other_last_name", "provider_other_first_name",
			"provider_other_middle_name", "provider_other_name_prefix",
			"provider_other_name_suffix", "provider_other_credential",
			"provider_other_last_name_type_code", "provider_enumeration_date",
			"last_update_date", "npi_deactivation_reason_code",
			"npi_deactivation_date", "npi_reactivation_date",
			"provider_gender_code", "authorized_official_last_name",
			"authorized_official_first_name", "authorized_official_middle_name",
			"authorized_official_titleor_position", "authorized_official_telephone_number",
			"is_sole_proprietor", "is_organization_subpart",
			"parent_organization_lbn", "parent_organization_tin",
			"authorized_official_name_prefix", "authorized_official_name_suffix",
			"authorized_official_credential"}
		output = output + insertProvider +
			createInsert(providerHeaders[:], record, nppesHeaders, false) + ");"
		mailingHeaders := [...]string{"provider_first_line_business_mailing_address", "provider_second_line_business_mailing_address",
			"provider_business_mailing_address_city_name", "provider_business_mailing_address_state_name",
			"provider_business_mailing_address_postal_code", "provider_business_mailing_address_country_code_if_outside_us",
			"provider_business_mailing_address_telephone_number", "provider_business_mailing_address_fax_number", "npi"}
		output = output + insertAddress + "'mailing'," +
			createInsert(mailingHeaders[:], record, nppesHeaders, false) + ");"
		practiceLocationHeaders := [...]string{"provider_first_line_business_practice_location_address", "provider_second_line_business_practice_location_address",
			"provider_business_practice_location_address_city_name", "provider_business_practice_location_address_state_name",
			"provider_business_practice_location_address_postal_code", "provider_business_practice_location_address_country_code_out_us",
			"provider_business_practice_location_address_telephone_number", "provider_business_practice_location_address_fax_number", "npi"}
		output = output + insertAddress + "'practice_location'," +
			createInsert(practiceLocationHeaders[:], record, nppesHeaders, false) + ");"

		for j := 1; j <= 15; j++ {
			taxonomyGroupHeaders := [...]string{fmt.Sprintf("healthcare_provider_taxonomy_group_%d", j), "npi"}
			toInsert := createInsert(taxonomyGroupHeaders[:], record, nppesHeaders, true)
			if toInsert == "" {
				continue
			}
			output = output + insertHealthcareProviderTaxonomyGroup + toInsert + ");"
		}
		for j := 1; j <= 50; j++ {
			otherProviderHeaders := [...]string{fmt.Sprintf("other_provider_identifier_%d", j), fmt.Sprintf("other_provider_identifier_type_code_%d", j),
				fmt.Sprintf("other_provider_identifier_state_%d", j), fmt.Sprintf("other_provider_identifier_issuer_%d", j), "npi"}
			toInsert := createInsert(otherProviderHeaders[:], record, nppesHeaders, true)
			if toInsert == "" {
				continue
			}
			output = output + insertOtherProvider + toInsert + ");"
		}
		for j := 1; j <= 15; j++ {
			taxonomyLicenseHeaders := [...]string{fmt.Sprintf("healthcare_provider_taxonomy_code_%d", j), fmt.Sprintf("provider_license_number_%d", j),
				fmt.Sprintf("provider_license_number_state_code_%d", j), fmt.Sprintf("healthcare_provider_primary_taxonomy_switch_%d", j), "npi"}
			toInsert := createInsert(taxonomyLicenseHeaders[:], record, nppesHeaders, true)
			if toInsert == "" {
				continue
			}
			output = output + insertTaxonomyTable + toInsert + ");"
		}

		//duration := time.Now().Sub(startingTime)
		//durationAsInt64 := int64(duration.Seconds())

		if i%50 == 0 {
			go db.Exec(output)
			//fmt.Println("Finished parsing group ", float64(i)/float64(durationAsInt64))
			output = ""
			// if durationAsInt64 >= 30 {
			// 	fmt.Println("Finished parsing", durationAsInt64)
			// 	break
			// }
		}
		i++
	}

	fmt.Println("Finished parsing", time.Now(), i)
}

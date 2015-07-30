**Search Providers**
----
  Returns json data listing providers that match provided search terms.

* **URL**

  /api/v1/providers

* **Method:**

  `GET`
  
* **URL Parameters**

  All parameters are optional, and can be combined to create more complex searches. If multiple search parameters are supplied they are combined using an implicit AND operator. Any parameter that accepts a string can use the following special search terms:

  OR: return results that match either term; example: `location=chicago+OR+miami`

  AND: return results that match both terms; example: `name=lee+AND+johnathan`

  NOT: return results that do not match the term; example: `location=NOT+baltimore`

  *: wildcard character for partial matching; example: `name=carruthe*`


  * `q=[string]`

    Generic search query that searches across all available fields (NPI, name, location, specialization, organization name)

  * `name=[string]`

    Search query that searches across provider names

  * `location=[string]`

    Search query that searches across provider location (city and zip code)

  * `taxonomy=[string]`

    Search query that searches across provider specializations

  * `organization=[string]`

    Search query that searches across provider organization affiliations

  * `npi=[integer]`

    Search query that searches against provider NPI

  * `geo_zip=[integer]`

    Search query that searches for providers within a specified radius of the provided zip code; if no radius is provided using the `radius` parameter, a default of 1 mile is used

  * `latitude=[float]`
  * `longitude=[float]`

    Search query that searches for providers within a specified radius of the provided latitude and longitude; if no radius is provided using the `radius` parameter, a default of 1 mile is used

  * `radius=[float]`

    For search queries that use geolocation (`geo_zip`, `latitude` and `longitude`), this specifies the radius in miles for the search area

* **Success Response:**

  * **Code:** 200 <br />
    **Content:** `{"meta":{"totalResults":1,"resultsPerPage":10},"providers":[{"npi":[npi],"last_name_legal_name":"[LAST NAME]","first_name":"[FIRST NAME]","gender_code":"F","mailing_address":{"first_line":"[ADDRESS]","second_line":"[ADDRESS]","city":"[CITY]","state":"[STATE]","postal_code":"[ZIP]","country_code":"[COUNTRY]","telephone_number":"[PHONE NUMBER]"},"practice_location_address":{"first_line":"[ADDRESS]","second_line":"[ADDRESS]","city":"[CITY]","state":"[STATE]","postal_code":"[ZIP]","country_code":"[COUNTRY]","telephone_number":"[PHONE NUMBER]"},"taxonomy_licenses":[{"code":"[CODE]","taxonomy_code":{"code":"[CODE]","taxonomy_type":"[TYPE]","classification":"[CLASSIFICATION]"}}]}]}`
 
* **Error Response:**

  * **Code:** 400 BAD REQUEST <br />
    **Content:** `{ error : "Invalid Query Syntax" }`

* **Sample Call:**

  ```javascript
    $.ajax({
      url: "/api/v1/providers.json?q=lee",
      dataType: "json",
      type : "GET",
      success : function(r) {
        console.log(r);
      }
    });
  ```

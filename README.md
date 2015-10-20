## Medirectory README

Medirectory is a prototype healthcare directory, built to explore the technical aspects of building a directory. Medirectory

* Is populated using the NPPES provider and organization data sets, along with the Physician Compare data set

* Provides a robust RESTful interface, designed for machine-to-machine communication, providing

  * search by basic information like name, location, specialty, and NPI

  * complex queries using organizational relationships

  * search using boolean operators such as OR, AND, and NOT

  * geospatial search, searching within a radius

* Includes a web interface to demonstrate interactions with the RESTful interface, essentially a JavaScript client to the RESTful interface

* Provides initial support for an IHE HPD interface

* Provides initial support for a FHIR interface, supporting the Practitioner FHIR resource

This repository contains the RESTful backend, FHIR interface, and IHE HPD interface. The frontend web interface is in a [separate repository](https://github.com/Medirectory/medirectory-frontend).

### License

Copyright 2015 The MITRE Corporation

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

```
http://www.apache.org/licenses/LICENSE-2.0
```

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.


### Installation and Setup

The Medirectory backend is a Ruby on Rails application. In order to work with the application, you will need to install some prequesites.

#### Prerequisites

* [Git](http://git-scm.com/)

* [Ruby](https://www.ruby-lang.org/)

* [Go](https://golang.org/)

* [Postgres](http://www.postgresql.org/)

Once the prequesites are available, Medirectory can be installed and data can be imported and indexed.

#### Setup

* Retrieve the application source code

    `git clone https://github.com/Medirectory/medirectory.git`

* Change into the new directory

    `cd medirectory`

* Create the database

    `bundle exec rake db:drop db:create db:migrate RAILS_ENV=development`

* Load taxonomy information (information on provider specializatiopns)

    `bundle exec rake medirectory:load_taxonomy_map`

* Download the NPPES data file, located [on the CMS site](http://download.cms.gov/nppes/NPI_Files.html), and unzip the CSV file

* Load the NPPES data file, replacing [CSV FILE] with the actual file name

    `go run db/parsing/csvRun.go medirectory_development [CSV FILE]`

* Match providers and organizations using a heuristic algorithm

    `bundle exec rake medirectory:match_providers_organizations`

* Optionally download the [Physicial Compare data file](https://data.medicare.gov/data/physician-compare) and load it, replacing [CSV FILE] with the actual file name

    `bundle exec rake medirectory:add_physician_compare_data FILE='[CSV FILE]'`

* Populate the search indexes; this may take some time

    `bundle exec rake medirectory:populate_search`

* Populate Electronic Service Information with synthetic data

    `bundle exec rake medirectory:populate_electronic_services`

* Set up geospatial search indexes

    `bundle exec rake medirectory:load_zip_codes`

    `bundle exec rake medirectory:match_addresses_to_lat_long`

    `bundle exec rake medirectory:populate_lat_long`

* Run tests

    `bundle exec rake db:drop db:create db:migrate RAILS_ENV=test` (first time only)

    `bundle exec rake test`

* Run the application server

    `bundle exec rails server`

    The server will be running at http://localhost:3000/

## API documentation

The documentation for the generic RESTful and FHIR APIs is integrated directly into the application, and can be accessed when running the application by connecting to http://localhost:3000/docs/api/

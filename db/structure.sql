--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: cube; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS cube WITH SCHEMA public;


--
-- Name: EXTENSION cube; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION cube IS 'data type for multidimensional cubes';


--
-- Name: earthdistance; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS earthdistance WITH SCHEMA public;


--
-- Name: EXTENSION earthdistance; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION earthdistance IS 'calculate great-circle distances on the surface of the Earth';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE addresses (
    id integer NOT NULL,
    type character varying,
    first_line character varying,
    second_line character varying,
    city character varying,
    state character varying,
    postal_code character varying,
    country_code character varying,
    telephone_number character varying,
    fax_number character varying,
    entity_id integer,
    entity_type character varying,
    latitude numeric(15,10) DEFAULT 0.0,
    longitude numeric(15,10) DEFAULT 0.0
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE addresses_id_seq OWNED BY addresses.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations (
    npi integer NOT NULL,
    entity_type_code integer,
    ein character varying,
    replacement_npi integer,
    organization_name_legal_business_name character varying,
    other_organization_name character varying,
    other_organization_name_type_code character varying,
    enumeration_date date,
    last_update_date date,
    npi_deactivation_code character varying,
    npi_deactivation_date date,
    npi_reactivation_date date,
    authorized_official_last_name character varying,
    authorized_official_first_name character varying,
    authorized_official_middle_name character varying,
    authorized_official_name_prefix character varying,
    authorized_official_name_suffix character varying,
    authorized_official_credential character varying,
    authorized_official_titleor_position character varying,
    authorized_official_telephone_number character varying,
    is_organization_subpart character varying,
    parent_organization_lbn character varying,
    parent_organization_tin character varying,
    searchable_name character varying,
    searchable_authorized_official character varying,
    searchable_location character varying,
    searchable_taxonomy character varying,
    searchable_content character varying,
    searchable_providers character varying
);


--
-- Name: organizations_providers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE organizations_providers (
    organization_id integer,
    provider_id integer
);


--
-- Name: other_provider_identifiers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE other_provider_identifiers (
    id integer NOT NULL,
    identifier character varying,
    identifier_type_code character varying,
    identifier_state character varying,
    identifier_issuer character varying,
    entity_id integer,
    entity_type character varying
);


--
-- Name: other_provider_identifiers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE other_provider_identifiers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: other_provider_identifiers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE other_provider_identifiers_id_seq OWNED BY other_provider_identifiers.id;


--
-- Name: providers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE providers (
    npi integer NOT NULL,
    entity_type_code integer,
    replacement_npi integer,
    last_name_legal_name character varying,
    first_name character varying,
    middle_name character varying,
    name_prefix character varying,
    name_suffix character varying,
    credential character varying,
    other_last_name character varying,
    other_first_name character varying,
    other_middle_name character varying,
    other_name_prefix character varying,
    other_name_suffix character varying,
    other_credential character varying,
    other_last_name_type_code integer,
    enumeration_date date,
    last_update_date date,
    npi_deactivation_reason_code character varying,
    npi_deactivation_date date,
    npi_reactivation_date date,
    gender_code character varying,
    is_sole_proprietor character varying,
    searchable_name character varying,
    searchable_location character varying,
    searchable_taxonomy character varying,
    searchable_content character varying,
    searchable_organization character varying
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: searches; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW searches AS
 SELECT providers.npi,
    providers.npi AS entity_id,
    'Provider'::text AS entity_type,
    providers.last_name_legal_name,
    providers.first_name,
    providers.middle_name,
    providers.other_last_name,
    providers.other_first_name,
    providers.other_middle_name
   FROM providers
UNION
 SELECT organizations.npi,
    organizations.npi AS entity_id,
    'Organization'::text AS entity_type,
    organizations.organization_name_legal_business_name AS last_name_legal_name,
    organizations.other_organization_name AS first_name,
    organizations.authorized_official_last_name AS middle_name,
    organizations.authorized_official_first_name AS other_last_name,
    organizations.authorized_official_middle_name AS other_first_name,
    organizations.authorized_official_telephone_number AS other_middle_name
   FROM organizations;


--
-- Name: taxonomy_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taxonomy_codes (
    id integer NOT NULL,
    code character varying,
    taxonomy_type character varying,
    classification character varying,
    specialization character varying,
    definition character varying,
    notes character varying
);


--
-- Name: taxonomy_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taxonomy_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxonomy_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taxonomy_codes_id_seq OWNED BY taxonomy_codes.id;


--
-- Name: taxonomy_groups; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taxonomy_groups (
    id integer NOT NULL,
    taxonomy_group character varying,
    entity_id integer,
    entity_type character varying
);


--
-- Name: taxonomy_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taxonomy_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxonomy_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taxonomy_groups_id_seq OWNED BY taxonomy_groups.id;


--
-- Name: taxonomy_licenses; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taxonomy_licenses (
    id integer NOT NULL,
    code character varying,
    license_number character varying,
    license_number_state_code character varying,
    primary_taxonomy_switch character varying,
    entity_id integer,
    entity_type character varying
);


--
-- Name: taxonomy_licenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taxonomy_licenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taxonomy_licenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taxonomy_licenses_id_seq OWNED BY taxonomy_licenses.id;


--
-- Name: zip_codes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE zip_codes (
    id integer NOT NULL,
    country_code character varying,
    postal_code character varying,
    place_name character varying,
    state character varying,
    state_code character varying,
    city character varying,
    city_code character varying,
    community character varying,
    community_code character varying,
    latitude numeric(15,10) DEFAULT 0.0,
    longitude numeric(15,10) DEFAULT 0.0,
    accuracy integer
);


--
-- Name: zip_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE zip_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: zip_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE zip_codes_id_seq OWNED BY zip_codes.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY addresses ALTER COLUMN id SET DEFAULT nextval('addresses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY other_provider_identifiers ALTER COLUMN id SET DEFAULT nextval('other_provider_identifiers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taxonomy_codes ALTER COLUMN id SET DEFAULT nextval('taxonomy_codes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taxonomy_groups ALTER COLUMN id SET DEFAULT nextval('taxonomy_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taxonomy_licenses ALTER COLUMN id SET DEFAULT nextval('taxonomy_licenses_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY zip_codes ALTER COLUMN id SET DEFAULT nextval('zip_codes_id_seq'::regclass);


--
-- Name: addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (npi);


--
-- Name: other_provider_identifiers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY other_provider_identifiers
    ADD CONSTRAINT other_provider_identifiers_pkey PRIMARY KEY (id);


--
-- Name: providers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY providers
    ADD CONSTRAINT providers_pkey PRIMARY KEY (npi);


--
-- Name: taxonomy_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taxonomy_codes
    ADD CONSTRAINT taxonomy_codes_pkey PRIMARY KEY (id);


--
-- Name: taxonomy_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taxonomy_groups
    ADD CONSTRAINT taxonomy_groups_pkey PRIMARY KEY (id);


--
-- Name: taxonomy_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taxonomy_licenses
    ADD CONSTRAINT taxonomy_licenses_pkey PRIMARY KEY (id);


--
-- Name: zip_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY zip_codes
    ADD CONSTRAINT zip_codes_pkey PRIMARY KEY (id);


--
-- Name: addresses_ll_to_earth_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX addresses_ll_to_earth_idx ON addresses USING gist (ll_to_earth((latitude)::double precision, (longitude)::double precision));


--
-- Name: index_addresses_on_city; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_city ON addresses USING btree (city);


--
-- Name: index_addresses_on_entity_type_and_entity_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_entity_type_and_entity_id ON addresses USING btree (entity_type, entity_id);


--
-- Name: index_addresses_on_fax_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_fax_number ON addresses USING btree (fax_number);


--
-- Name: index_addresses_on_first_line; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_first_line ON addresses USING btree (first_line);


--
-- Name: index_addresses_on_postal_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_postal_code ON addresses USING btree (postal_code);


--
-- Name: index_addresses_on_second_line; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_second_line ON addresses USING btree (second_line);


--
-- Name: index_addresses_on_state; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_state ON addresses USING btree (state);


--
-- Name: index_addresses_on_telephone_number; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_addresses_on_telephone_number ON addresses USING btree (telephone_number);


--
-- Name: index_organizations_providers_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_providers_on_organization_id ON organizations_providers USING btree (organization_id);


--
-- Name: index_organizations_providers_on_provider_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_organizations_providers_on_provider_id ON organizations_providers USING btree (provider_id);


--
-- Name: index_other_provider_identifiers_on_entity_type_and_entity_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_other_provider_identifiers_on_entity_type_and_entity_id ON other_provider_identifiers USING btree (entity_type, entity_id);


--
-- Name: index_taxonomy_codes_on_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxonomy_codes_on_code ON taxonomy_codes USING btree (code);


--
-- Name: index_taxonomy_groups_on_entity_type_and_entity_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxonomy_groups_on_entity_type_and_entity_id ON taxonomy_groups USING btree (entity_type, entity_id);


--
-- Name: index_taxonomy_licenses_on_entity_type_and_entity_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taxonomy_licenses_on_entity_type_and_entity_id ON taxonomy_licenses USING btree (entity_type, entity_id);


--
-- Name: index_zip_codes_on_postal_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_zip_codes_on_postal_code ON zip_codes USING btree (postal_code);


--
-- Name: organizations_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organizations_to_tsvector_idx ON organizations USING gin (to_tsvector('simple'::regconfig, (searchable_name)::text));


--
-- Name: organizations_to_tsvector_idx1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organizations_to_tsvector_idx1 ON organizations USING gin (to_tsvector('simple'::regconfig, (searchable_authorized_official)::text));


--
-- Name: organizations_to_tsvector_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organizations_to_tsvector_idx2 ON organizations USING gin (to_tsvector('simple'::regconfig, (searchable_location)::text));


--
-- Name: organizations_to_tsvector_idx3; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organizations_to_tsvector_idx3 ON organizations USING gin (to_tsvector('simple'::regconfig, (searchable_taxonomy)::text));


--
-- Name: organizations_to_tsvector_idx4; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organizations_to_tsvector_idx4 ON organizations USING gin (to_tsvector('simple'::regconfig, (searchable_content)::text));


--
-- Name: organizations_to_tsvector_idx5; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX organizations_to_tsvector_idx5 ON organizations USING gin (to_tsvector('simple'::regconfig, (searchable_providers)::text));


--
-- Name: providers_to_tsvector_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX providers_to_tsvector_idx ON providers USING gin (to_tsvector('simple'::regconfig, (searchable_name)::text));


--
-- Name: providers_to_tsvector_idx1; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX providers_to_tsvector_idx1 ON providers USING gin (to_tsvector('simple'::regconfig, (searchable_location)::text));


--
-- Name: providers_to_tsvector_idx2; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX providers_to_tsvector_idx2 ON providers USING gin (to_tsvector('simple'::regconfig, (searchable_taxonomy)::text));


--
-- Name: providers_to_tsvector_idx3; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX providers_to_tsvector_idx3 ON providers USING gin (to_tsvector('simple'::regconfig, (searchable_content)::text));


--
-- Name: providers_to_tsvector_idx4; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX providers_to_tsvector_idx4 ON providers USING gin (to_tsvector('simple'::regconfig, (searchable_organization)::text));


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20150519200957');

INSERT INTO schema_migrations (version) VALUES ('20150519203016');

INSERT INTO schema_migrations (version) VALUES ('20150519203738');

INSERT INTO schema_migrations (version) VALUES ('20150519204059');

INSERT INTO schema_migrations (version) VALUES ('20150519204229');

INSERT INTO schema_migrations (version) VALUES ('20150520152141');

INSERT INTO schema_migrations (version) VALUES ('20150604143722');

INSERT INTO schema_migrations (version) VALUES ('20150605201709');

INSERT INTO schema_migrations (version) VALUES ('20150610004702');

INSERT INTO schema_migrations (version) VALUES ('20150616141206');

INSERT INTO schema_migrations (version) VALUES ('20150617171010');

INSERT INTO schema_migrations (version) VALUES ('20150617201209');

INSERT INTO schema_migrations (version) VALUES ('20150622153049');

INSERT INTO schema_migrations (version) VALUES ('20150623194217');

INSERT INTO schema_migrations (version) VALUES ('20150720125423');

INSERT INTO schema_migrations (version) VALUES ('20150720145610');

INSERT INTO schema_migrations (version) VALUES ('20150720174322');


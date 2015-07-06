
class Api::V1::FhirPractitionersController < ApplicationController
  SERIALIZATION_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
       {taxonomy_licenses: {include: :taxonomy_code}}, :taxonomy_groups, :organizations ]
  LOAD_INCLUDES = [:mailing_address, :practice_location_address, :other_provider_identifiers,
       {taxonomy_licenses: :taxonomy_code}, :taxonomy_groups, :organizations ]
  RESULTS_PER_PAGE = 10

  def index
    # Basic search functionality
    providers = if params[:q]
                  Provider.basic_search(searchable_content: params[:q])
                elsif params[:fuzzy_q]
                  Provider.fuzzy_search(searchable_content: params[:fuzzy_q])
                else
                  Provider.all
                end

    # Layer advanced search parameters onto existing results
    if params[:name]
      providers = providers.basic_search(searchable_name: params[:name])
    end
    if params[:location]
      providers = providers.basic_search(searchable_location: params[:location])
    end
    if params[:taxonomy]
      providers = providers.basic_search(searchable_taxonomy: params[:taxonomy])
    end
    if params[:organization]
      providers = providers.basic_search(searchable_organization: params[:organization])
    end
    if params[:npi]
      providers = providers.where(npi: params[:npi])
    end

    # We want to provide a total in addition to a paginated subset of the results
    # Note: If we don't have query parameters (all results), this is quite slow; if we need this, see
    # http://stackoverflow.com/questions/16916633/if-postgresql-count-is-always-slow-how-to-paginate-complex-queries
    count = providers.size

    # Add a secondary order to break search rank ties (which seem to create indeterminism)
    providers = providers.order(:npi)

    providers = providers.includes(LOAD_INCLUDES)
    providers = providers.offset(params[:offset]).limit(RESULTS_PER_PAGE)

    respond_to do |format|
      format.xml { render xml: providers, include: SERIALIZATION_INCLUDES }
      format.json { render json: MultiJson.encode(meta: { totalResults: count, resultsPerPage: RESULTS_PER_PAGE },
                                                  providers: providers.as_json(include: SERIALIZATION_INCLUDES))}
    end
  end

  def show
    provider = Provider.includes(LOAD_INCLUDES).find(params[:id])
    #@provider = provider
    practitioner = Practitioner.from_provider(provider)
    respond_to do |format|
      format.xml {render :partial => "api/v1/fhir_practitioners/show.xml.erb", locals: { provider: provider} }
      format.json { render json: MultiJson.encode(practitioner) }
    end
  end
end
class Practitioner 

  def initialize(identifier, name, telecom, address, 
    gender, birthDate, photo, organization, role, 
    specialty, period, location, qualification, communication)
    @identifier = identifier if identifier
    @name = name 
    @telecom = telecom 
    @address = address 
    @gender = gender 
    @birthDate = birthDate 
    @photo = photo if photo
    @organization = organization if organization
    @role = role if role
    @specialty = specialty if specialty
    @period = period 
    @location = location if location
    @qualification = qualification if qualification
    @communication = communication if communication
  end

  def self.from_provider(provider)
    {
      identifier: nil,
      name:  HumanName.from_provider("official", provider),
      telecom:   [
        Contact.from_provider("phone", provider.mailing_address.telephone_number, "work"),
        Contact.from_provider("fax", provider.mailing_address.fax_number, "work"),
        Contact.from_provider("phone", provider.practice_location_address.telephone_number, "work"),
        Contact.from_provider("fax", provider.practice_location_address.fax_number, "work")
      ],
      address:  [AddressFhir.from_provider("work", provider.mailing_address), AddressFhir.from_provider("work", provider.practice_location_address)], 
      gender:  { coding: provider.gender_code, text: provider.gender_code},
      birthDate:  nil,
      photo:  nil,
      organization:  nil,
      role:  nil, 
      specialty:  nil,
      period:  {start: provider.enumeration_date, end: provider.npi_deactivation_date}, #start will be npi start time, end if deatictivation exists and no reactivation
      location:  nil, 
      qualification:  nil,
      communication:  nil,
    }
  end

  class HumanName 

    def initialize(use, text, family, given, prefix, suffix, period)
      @use = use 
      @text = text
      @family = family
      @given = given
      @prefix = prefix 
      @suffix = suffix 
      @period = period if period
    end

    def self.from_provider(use, provider)
      {
        use: use,
        text: provider.first_name.to_s+ " " + provider.middle_name.to_s + " " + provider.last_name_legal_name.to_s,
        family: provider.last_name_legal_name,
        given: provider.first_name,
        prefix: provider.name_prefix,
        suffix: provider.name_suffix,
        period: nil
      }
    end

  end

  class CodeableConcept 

    def initialize(coding, text)
      @coding = coding 
      @text = text 
    end

  end

  class Contact 

    def initialize(system, value, use, period)
      @system = system 
      @value = value 
      @use = use 
      @period = period if period
    end

    def self.from_provider(system, number, use)
      {
        system: system,
        value: number,
        use: use,
        period: nil
      }
    end

  end

  class Period 

    def initialize(start, endTime)
      @start = start
      @end = endTime
    end

  end

  class AddressFhir

    def initialize(use, text, line, city, state, zip, country, period)
      @use = use
      @text = text
      @line = line
      @city = city
      @state = state
      @zip = zip
      @country = country
      @period = period if period
    end

    def self.from_provider(use, address)
      {
        use:  use,
        text:  address.first_line.to_s+ ", " + address.second_line.to_s + ", " + address.city.to_s + ", " + address.state.to_s + ", " + address.postal_code.to_s + ", " + address.country_code.to_s,
        line:  address.first_line.to_s+ ", " + address.second_line.to_s,
        city:  address.city,
        state:  address.state,
        zip:  address.postal_code,
        country:  address.country_code,
        period:  nil
      }
    end

  end

end


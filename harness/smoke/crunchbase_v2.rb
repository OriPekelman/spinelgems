# smoke: crunchbase_v2
# Exercises model constructors with synthetic JSON data (no network calls needed).
# Covers Organization, Person, Relationship, Category, Website, CBEntity helpers.
require 'crunchbase'

# -- Organization from synthetic JSON --
org_json = {
  'uuid' => 'abc-123',
  'type' => 'Organization',
  'properties' => {
    'name'                  => 'Acme Corp',
    'permalink'             => 'acme-corp',
    'role_company'          => true,
    'role_investor'         => false,
    'primary_role'          => 'company',
    'description'           => 'A test company',
    'short_description'     => 'Test Co',
    'homepage_url'          => 'https://acme.example.com',
    'email_address'         => 'hi@acme.example.com',
    'phone_number'          => '+1-555-0100',
    'founded_on'            => '2000-01-15',
    'founded_on_day'        => 15,
    'founded_on_month'      => 1,
    'founded_on_year'       => 2000,
    'founded_on_trust_code' => 4,
    'is_closed'             => false,
    'closed_on'             => nil,
    'closed_on_day'         => nil,
    'closed_on_month'       => nil,
    'closed_on_year'        => nil,
    'closed_on_trust_code'  => nil,
    'total_funding_usd'     => 5_000_000,
    'number_of_investments' => 3,
    'number_of_employees'   => 42,
    'stock_symbol'          => nil,
    'stock_exchange'        => nil,
    'num_employees_max'     => 50,
    'num_employees_min'     => 30,
    'secondary_role_for_profit' => true,
    'investors'             => [],
    'created_at'            => 1000000000,
    'updated_at'            => 1200000000,
  },
  'relationships' => {
    'past_team'                    => nil,
    'sub_organizations'            => nil,
    'current_team'                 => nil,
    'acquisitions'                 => nil,
    'competitors'                  => nil,
    'offices'                      => nil,
    'headquarters'                 => nil,
    'funding_rounds'               => {
      'paging' => { 'total_items' => 1 },
      'items'  => [
        {
          'type'  => 'FundingRound',
          'name'  => 'Series A',
          'path'  => 'funding-round/series-a-abc',
          'created_at' => 1100000000,
          'updated_at' => 1200000000,
        }
      ]
    },
    'categories'                   => {
      'paging' => { 'total_items' => 1 },
      'items'  => [
        {
          'type'  => 'Category',
          'name'  => 'Software',
          'uuid'  => 'cat-001',
          'path'  => 'category/software',
          'created_at' => 1000000000,
          'updated_at' => 1000000000,
          'number_of_organizations' => 100,
        }
      ]
    },
    'customers'                    => nil,
    'investments'                  => nil,
    'founders'                     => {
      'paging' => { 'total_items' => 1 },
      'items'  => [
        {
          'type'  => 'Person',
          'name'  => 'Jane Doe',
          'path'  => 'person/jane-doe',
          'created_at' => 1000000000,
          'updated_at' => 1100000000,
        }
      ]
    },
    'ipo'                          => nil,
    'products'                     => nil,
    'primary_image'                => nil,
    'images'                       => nil,
    'websites'                     => {
      'paging' => { 'total_items' => 1 },
      'items'  => [
        {
          'type'       => 'WebPresence',
          'url'        => 'https://acme.example.com',
          'title'      => 'Homepage',
          'created_at' => 1000000000,
          'updated_at' => 1000000000,
        }
      ]
    },
    'news'                         => nil,
    'board_members_and_advisors'   => nil,
    'acquired_by'                  => nil,
  }
}

org = Crunchbase::Organization.new(org_json)

puts "name=#{org.name}"
puts "permalink=#{org.permalink}"
puts "uuid=#{org.uuid}"
puts "primary_role=#{org.primary_role}"
puts "total_funding_usd=#{org.total_funding_usd}"
puts "number_of_employees=#{org.number_of_employees}"
puts "founded_on_year=#{org.founded_on_year}"
puts "is_closed=#{org.is_closed}"
puts "created_at=#{org.created_at}"

# Relationship collections (lazily built)
cats = org.categories
puts "categories_count=#{cats.size}"
puts "category_name=#{cats.first.name}"
puts "category_uuid=#{cats.first.uuid}"

founders = org.founders
puts "founders_count=#{founders.size}"
puts "founder_name=#{founders.first.name}"
puts "founder_permalink=#{founders.first.permalink}"

websites = org.websites
puts "websites_count=#{websites.size}"
puts "website_url=#{websites.first.url}"
puts "website_title=#{websites.first.title}"

# funding_rounds via Relationship (items without full properties hash)
frs = org.funding_rounds
puts "funding_rounds_count=#{frs.size}"
puts "funding_round_name=#{frs.first.name}"

# total_items helpers (nil-safe)
puts "categories_total=#{org.categories_total_items}"
puts "founders_total=#{org.founders_total_items}"

# -- Person from synthetic JSON --
person_json = {
  'uuid' => 'per-456',
  'type' => 'Person',
  'properties' => {
    'first_name'   => 'Jane',
    'last_name'    => 'Doe',
    'permalink'    => 'jane-doe',
    'bio'          => 'Founder of Acme Corp',
    'born_on'      => '1980-06-01',
    'died_on'      => nil,
    'is_deceased'  => false,
    'homepage_url' => 'https://janedoe.example.com',
    'created_at'   => 1000000000,
    'updated_at'   => 1100000000,
  },
  'relationships' => {
    'degrees'              => nil,
    'experience'           => nil,
    'primary_location'     => nil,
    'primary_affiliation'  => nil,
    'investments'          => nil,
    'advisor_at'           => nil,
    'founded_companies'    => nil,
    'primary_image'        => nil,
    'videos'               => nil,
    'websites'             => nil,
    'news'                 => nil,
  }
}

person = Crunchbase::Person.new(person_json)
puts "person_name=#{person.name}"
puts "person_first=#{person.first_name}"
puts "person_last=#{person.last_name}"
puts "person_permalink=#{person.permalink}"
puts "person_bio=#{person.bio}"
puts "person_born_on=#{person.born_on}"
puts "person_degrees=#{person.degrees.inspect}"

# -- SearchResult / Relationship --
rel_hash = {
  'type'       => 'Organization',
  'name'       => 'Beta Inc',
  'path'       => 'organization/beta-inc',
  'created_at' => 1050000000,
  'updated_at' => 1150000000,
}
sr = Crunchbase::SearchResult.new(rel_hash)
puts "search_result_name=#{sr.name}"
puts "search_result_permalink=#{sr.permalink}"
puts "search_result_type=#{sr.type_name}"

# -- CBEntity nil-list guards --
puts "nil_list_total=#{Crunchbase::Category.total_items_from_list(nil)}"
puts "nil_list_array=#{Crunchbase::Category.array_from_list(nil).inspect}"

# -- VERSION constant --
puts "version=#{Crunchbase::VERSION}"

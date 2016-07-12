# Following tutorial at http://blog.datagraph.org/2010/04/parsing-rdf-with-ruby
require 'rdf'
require 'linkeddata'
require 'sparql'
require 'net/http'
require 'openssl'

def abstract_for(interest)
  tmp_query = "PREFIX foaf: <http://xmlns.com/foaf/0.1/>
    PREFIX dbo: <http://dbpedia.org/ontology/>
    SELECT ?abs
      WHERE { ?s dbo:abstract ?abs
        FILTER (lang(?abs) = 'en')}"
  tmp_graph = RDF::Graph.load(interest)
  sparql_query_abstracts = SPARQL.parse(tmp_query)
  sparql_query_abstracts.execute(tmp_graph) do |res|
    puts res.abs
  end
end

graph = RDF::Graph.load("foaf_files/laney.rdf")

puts graph.inspect

query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?o
  WHERE { ?s foaf:knows ?o }
"

puts "Before loading"
sparql_query = SPARQL.parse(query)
sparql_query.execute(graph) do |result|
  puts result.o
  triples = RDF::Resource(RDF::URI.new(result.o))
  graph.load(triples)
end

# puts "After loading"
# sparql_query.execute(graph) do |result|
#   puts result.o
# end

interest_query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?o
  WHERE { ?s foaf:interest ?o }
"
sparql_interest_query = SPARQL.parse(interest_query)
sparql_interest_query.execute(graph) do |result|
  abstract_for(result.o)
end

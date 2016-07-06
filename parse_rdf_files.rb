# Following tutorial at http://blog.datagraph.org/2010/04/parsing-rdf-with-ruby
require 'rdf'
require 'linkeddata'
require 'sparql'
require 'net/http'
require 'openssl'

graph = RDF::Graph.load("foaf_files/laney.rdf")

puts graph.inspect

query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?o
  WHERE { ?s foaf:knows ?o }
"

puts "Before loading"
sse = SPARQL.parse(query)
sse.execute(graph) do |result|
  puts result.o
  triples = RDF::Resource(RDF::URI.new(result.o))
  graph.load(triples)
end

puts "After loading"
sse.execute(graph) do |result|
  puts result.o
end

interest_query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT DISTINCT ?o
  WHERE { ?s foaf:interest ?o }
"

tmp_query = "PREFIX foaf: <http://xmlns.com/foaf/0.1/>
  PREFIX dbo: <http://dbpedia.org/ontology/>
  SELECT ?abs
    WHERE { ?s dbo:abstract ?abs
      FILTER (lang(?abs) = 'en')}"

tmp_graph = RDF::Graph.load("http://dbpedia.org/resource/Quilting")
sse_abstracts = SPARQL.parse(tmp_query)
sse_abstracts.execute(tmp_graph) do |res|
  puts res.abs
end

# puts "Interests"
# sse_interests = SPARQL.parse(interest_query)
# sse_interests.execute(graph) do |result|
#   puts result.o
#   abstract_query = "
#   PREFIX foaf: <http://xmlns.com/foaf/0.1/>
#   PREFIX dbo: <http://dbpedia.org/ontology/>
#   SELECT ?abs
#     WHERE { #{result.o} dbo:abstract ?abs }
#   "
#   puts abstract_query

  # puts "Abstracts"
  # sse_abstracts = SPARQL.parse(abstract_query)
  # sse_abstracts.execute("http://dbpedia.org/sparql") do |res_abs|
  #   puts res_abs.abs
  # end
#end

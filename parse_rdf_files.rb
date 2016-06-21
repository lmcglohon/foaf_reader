# Following tutorial at http://blog.datagraph.org/2010/04/parsing-rdf-with-ruby

require 'rdf'
require 'rdf/raptor'
require 'sparql'
require 'net/http'
require 'openssl'

# RDF::Reader.open("foaf_files/foaf.rdf") do |reader|
#   reader.each_statement do |statement|
#     puts statement.inspect
#   end
# end

graph = RDF::Graph.load("foaf_files/laney.rdf")

# puts graph.inspect

query = "
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
SELECT *
  WHERE { ?s foaf:knows ?o }
"

# queryable = RDF::Repository.load("foaf_files/foaf.rdf")
laney_rdf = RDF::Resource(RDF::URI.new("http://stanford.edu/~laneymcg/laney.rdf"))
hacker_nt = RDF::Resource(RDF::URI.new("http://datagraph.org/jhacker/foaf.nt"))
bess_rdf = RDF::Resource(RDF::URI.new("http://stanford.edu/~bess/foaf.rdf"))
tonyz_rdf = RDF::Resource(RDF::URI.new("https://web.stanford.edu/~azanella/me.rdf"))
laura_rdf = RDF::Resource(RDF::URI.new("http://stanford.edu/~laneymcg/laura.rdf"))

# Load multiple RDF files into the same RDF::Repository object
queryable = RDF::Repository.load(hacker_nt)
queryable.load(bess_rdf)
queryable.load(laney_rdf)
queryable.load(tonyz_rdf)
queryable.load(laura_rdf)

sse = SPARQL.parse(query)
sse.execute(queryable) do |result|
  puts result.o
end

namespace :import do
  desc "Importe les copropriétés depuis un CSV RNC (ANAH). Usage: bin/rails import:rnc[path=/chemin/vers/fichier.csv]"
  task :rnc, [ :path ] => :environment do |_task, args|
    path = args[:path] || ENV.fetch("RNC_CSV_PATH", nil)
    raise "Chemin CSV manquant. Ex: bin/rails import:rnc[/chemin/vers/rnc.csv]" if path.blank?

    commune_codes = ENV.fetch("COMMUNE_CODES", Copropriete.lyon_arrondissement_codes.join(",")).split(",")

    puts "Import RNC depuis #{path}"
    puts "Filtre communes: #{commune_codes.join(', ')}"

    result = RncImporter.call(path:, commune_codes:)
    puts "Import terminé: #{result[:imported]} copropriétés importées, #{result[:skipped]} lignes ignorées (hors périmètre)"
  end
end

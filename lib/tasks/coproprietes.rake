namespace :coproprietes do
  desc "Recalcule les scores de santé sur toutes les copropriétés"
  task recalculate_scores: :environment do
    count = 0
    Copropriete.find_each do |copropriete|
      copropriete.save!
      count += 1
    end
    puts "#{count} copropriétés recalculées"
  end
end

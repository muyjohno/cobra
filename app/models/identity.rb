class Identity < ApplicationRecord
  enum side: {
    corp: 1,
    runner: 2
  }

  ALIASES = {
    ci: '03001',
    gabe: '20019',
    aot: '11072',
    etf: '01054',
    ig: '06105',
    pe: '20093',
    pu: '11054',
    rp: '02031',
    ctm: '11017',
    twiy: '02114',
    neh: '06005',
    bwbi: '02076',
    bon: '11038',
    babw: '20077'
  }.with_indifferent_access.freeze

  def self.valid?(identity)
    Identity.exists?(name: identity)
  end

  def self.guess(text)
    return if text.nil? || text.length < 3

    Identity.find_by(nrdb_code: ALIASES[text.downcase]) ||
      Identity.find_by('lower(autocomplete) like ?', "%#{text.downcase}%")
  end
end

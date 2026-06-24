package services

// EnergyRuleEngine provides deterministic crystal recommendations
// based on zodiac sign, element, and user concerns.
// No external API needed — reliable and zero-cost.

type EnergyRecommendation struct {
	Element             string   `json:"element"`
	Explanation         string   `json:"explanation"`
	RecommendedColors   []string `json:"recommended_colors"`
	RecommendedMaterials []string `json:"recommended_materials"`
	EnergyFocus         string   `json:"energy_focus"`
	CrystalSuggestions  []string `json:"crystal_suggestions"`
}

var zodiacElements = map[string]string{
	"Aries": "Fire", "Leo": "Fire", "Sagittarius": "Fire",
	"Taurus": "Earth", "Virgo": "Earth", "Capricorn": "Earth",
	"Gemini": "Air", "Libra": "Air", "Aquarius": "Air",
	"Cancer": "Water", "Scorpio": "Water", "Pisces": "Water",
}

var elementData = map[string]struct {
	Colors    []string
	Materials []string
	Focus     string
	Explanation string
}{
	"Fire": {
		Colors:    []string{"red", "orange", "gold", "amber", "coral"},
		Materials: []string{"carnelian", "red jasper", "sunstone", "citrine", "gold"},
		Focus:     "Ignites passion, courage, and creative energy",
		Explanation: "Fire signs are bold, passionate, and driven. Your energy burns bright — you need stones that channel that fire without burning out.",
	},
	"Earth": {
		Colors:    []string{"green", "brown", "beige", "olive", "terracotta"},
		Materials: []string{"jade", "aventurine", "tiger eye", "hematite", "wood"},
		Focus:     "Grounds your spirit and cultivates stability",
		Explanation: "Earth signs are grounded, practical, and loyal. You thrive on stability — your bracelets should root you while letting you grow.",
	},
	"Air": {
		Colors:    []string{"blue", "silver", "white", "lavender", "sky blue"},
		Materials: []string{"amethyst", "lapis lazuli", "sodalite", "moonstone", "silver"},
		Focus:     "Sharpens intellect and opens communication",
		Explanation: "Air signs are intellectual, curious, and social. Your mind needs stimulation — crystals that clear mental fog and amplify your voice.",
	},
	"Water": {
		Colors:    []string{"deep blue", "aquamarine", "teal", "pearl", "silver"},
		Materials: []string{"aquamarine", "moonstone", "pearl", "amethyst", "labradorite"},
		Focus:     "Deepens intuition and emotional wisdom",
		Explanation: "Water signs are intuitive, emotional, and deep. You feel everything — crystals that soothe your soul and strengthen your inner knowing.",
	},
	"Wood": {
		Colors:    []string{"emerald green", "brown", "gold", "olive", "teal"},
		Materials: []string{"jade", "aventurine", "malachite", "wood", "chrysoprase"},
		Focus:     "Nurtures growth, vitality, and new beginnings",
		Explanation: "The Wood element represents growth, flexibility, and renewal. Like a bamboo in the wind, you bend without breaking — your energy expands upward.",
	},
	"Metal": {
		Colors:    []string{"white", "silver", "gray", "gold", "platinum"},
		Materials: []string{"hematite", "moonstone", "clear quartz", "silver", "gold"},
		Focus:     "Strengthens discipline, focus, and inner resolve",
		Explanation: "The Metal element embodies structure, precision, and clarity. Your spirit is refined and strong — stones that sharpen your focus and polish your will.",
	},
}

// concernCrystals maps common concerns to specific crystal recommendations.
var concernCrystals = map[string]struct {
	Crystals []string
	Focus    string
}{
	"stress":      {[]string{"amethyst", "howlite", "blue lace agate", "lepidolite"}, "Releases tension and restores inner peace"},
	"focus":       {[]string{"fluorite", "clear quartz", "sodalite", "tiger eye"}, "Sharpens concentration and mental clarity"},
	"sleep":       {[]string{"amethyst", "moonstone", "howlite", "selenite"}, "Promotes restful sleep and dream recall"},
	"love":        {[]string{"rose quartz", "rhodonite", "green aventurine", "garnet"}, "Opens the heart to love and compassion"},
	"wealth":      {[]string{"citrine", "pyrite", "green jade", "aventurine"}, "Attracts abundance and prosperity"},
	"confidence":  {[]string{"tiger eye", "carnelian", "sunstone", "goldstone"}, "Boosts self-esteem and personal power"},
	"creativity":  {[]string{"carnelian", "citrine", "sunstone", "sodalite"}, "Unlocks creative flow and inspiration"},
	"protection":  {[]string{"black tourmaline", "obsidian", "smoky quartz", "hematite"}, "Shields your energy field from negativity"},
	"anxiety":     {[]string{"amethyst", "howlite", "lepidolite", "blue kyanite"}, "Calms anxious thoughts and soothes nerves"},
	"balance":     {[]string{"jade", "aventurine", "unakite", "fluorite"}, "Harmonizes mind, body, and spirit"},
	"healing":      {[]string{"clear quartz", "rose quartz", "green aventurine", "carnelian"}, "Supports physical and emotional healing"},
	"career":      {[]string{"citrine", "pyrite", "tiger eye", "red jasper"}, "Amplifies ambition and career success"},
}

func NewEnergyRecommendations(zodiacSign, preferredElement, concerns, lifestyle string) []EnergyRecommendation {
	// Determine base element
	element := preferredElement
	if element == "" {
		element = zodiacElements[zodiacSign]
		if element == "" {
			element = "Earth" // default
		}
	}

	base := elementData[element]

	// Parse concerns into keywords
	crystals := base.Materials
	concernMatches := []string{"balance"}
	for keyword, data := range concernCrystals {
		if contains(concerns, keyword) {
			concernMatches = append(concernMatches, keyword)
			crystals = append(crystals, data.Crystals...)
		}
	}

	// Deduplicate crystals
	seen := make(map[string]bool)
	unique := []string{}
	for _, c := range crystals {
		if !seen[c] {
			seen[c] = true
			unique = append(unique, c)
		}
	}
	crystals = unique
	if len(crystals) > 8 {
		crystals = crystals[:8]
	}

	explanation := base.Explanation
	if len(concernMatches) > 1 {
		explanation += " We also detected your focus on " + concernMatches[len(concernMatches)-1] + " — these recommendations address that too."
	}
	if lifestyle != "" {
		explanation += " Your " + lifestyle + " lifestyle suggests you need a bracelet that fits your daily rhythm."
	}

	focus := base.Focus
	if c, ok := concernCrystals[concernMatches[0]]; ok {
		focus += " · " + c.Focus
	}

	rec := EnergyRecommendation{
		Element:             element,
		Explanation:         explanation,
		RecommendedColors:   base.Colors,
		RecommendedMaterials: base.Materials,
		EnergyFocus:         focus,
		CrystalSuggestions:  crystals,
	}

	return []EnergyRecommendation{rec}
}

func contains(s, substr string) bool {
	return len(s) >= len(substr) && searchSubstring(toLower(s), toLower(substr))
}

func searchSubstring(s, sub string) bool {
	for i := 0; i <= len(s)-len(sub); i++ {
		match := true
		for j := 0; j < len(sub); j++ {
			if s[i+j] != sub[j] {
				match = false
				break
			}
		}
		if match {
			return true
		}
	}
	return false
}

func toLower(s string) string {
	b := make([]byte, len(s))
	for i := 0; i < len(s); i++ {
		c := s[i]
		if c >= 'A' && c <= 'Z' {
			c += 32
		}
		b[i] = c
	}
	return string(b)
}

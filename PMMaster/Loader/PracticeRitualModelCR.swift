import Foundation

struct PracticeRitualModelCR: Identifiable, Codable, Hashable, Equatable {
    let id: String
    let title: String
    let trainingDomain: String
    let imageName: String
    let ritualDescription: String
    let precisionLevel: String
    let heatApplicationDuration: String
    let roastType: String
    let heatControlPhases: [HeatControlPhaseModelCR]
}

extension PracticeRitualModelCR {
    static let allPracticeRituals: [PracticeRitualModelCR] = [
        PracticeRitualModelCR(
            id: "perfect_ribeye",
            title: "Protocol: High-Density Fiber Matrix (Beef)",
            trainingDomain: "Beef",
            imageName: "beef_rare_cut",
            ritualDescription: "A structured training scenario for managing multi-phase heat distribution across high-density fiber matrices. Develops core capability in surface-to-core thermal stabilization and precision crust formation.",
            precisionLevel: "Developing",
            heatApplicationDuration: "25 minutes",
            roastType: "Beef",
            heatControlPhases: HeatControlPhaseModelCR.perfectRibeyePhases
        ),
        PracticeRitualModelCR(
            id: "pork_tenderloin",
            title: "Protocol: Lean Protein Structural Modification",
            trainingDomain: "Pork",
            imageName: "pork_roast_golden",
            ritualDescription: "Execute a training protocol for moisture retention in lean protein structures. Focuses on achieving specific fiber denaturation points and uniform thermal results.",
            precisionLevel: "Foundation",
            heatApplicationDuration: "30 minutes",
            roastType: "Pork",
            heatControlPhases: HeatControlPhaseModelCR.porkTenderloinPhases
        ),
        PracticeRitualModelCR(
            id: "whole_roast_chicken",
            title: "Protocol: Complex poultry Thermal Equilibrium",
            trainingDomain: "Chicken",
            imageName: "whole_chicken_roasted",
            ritualDescription: "Managing non-uniform biological structures under high-temperature conditions. This scenario develops core skills in achieving dual-target internal temperatures (white/dark structures).",
            precisionLevel: "Developing",
            heatApplicationDuration: "90 minutes",
            roastType: "Chicken",
            heatControlPhases: HeatControlPhaseModelCR.roastChickenPhases
        ),
        PracticeRitualModelCR(
            id: "lamb_rack",
            title: "Protocol: Precision Segmented Thermal Impact (Lamb)",
            trainingDomain: "Lamb",
            imageName: "lamb_chops_rack",
            ritualDescription: "High-precision segmenting of bone-adjacent protein structures. Focuses on minimizing thermal drift in delicate fiber matrices.",
            precisionLevel: "Precision",
            heatApplicationDuration: "35 minutes",
            roastType: "Lamb",
            heatControlPhases: HeatControlPhaseModelCR.lambRackPhases
        ),
        PracticeRitualModelCR(
            id: "salmon_fillet",
            title: "Protocol: Delicate Lipid-Rich Matrix (Fish)",
            trainingDomain: "Fish",
            imageName: "salmon_fillet_pink",
            ritualDescription: "Develop skills in managing heat application to sensitive lipid-heavy biological structures. Focuses on membrane integrity and rapid thermal response.",
            precisionLevel: "Foundation",
            heatApplicationDuration: "15 minutes",
            roastType: "Fish",
            heatControlPhases: HeatControlPhaseModelCR.salmonFilletPhases
        ),
        PracticeRitualModelCR(
            id: "beef_wellington",
            title: "Protocol: Multi-Layer Composite Structure Mastery",
            trainingDomain: "Beef",
            imageName: "beef_medium_rare",
            ritualDescription: "Advanced multi-stage training for composite structures with varying thermal conductivity. Manages heat through protein, vegetable, and flour-based barrier layers.",
            precisionLevel: "Precision",
            heatApplicationDuration: "120 minutes",
            roastType: "Beef",
            heatControlPhases: HeatControlPhaseModelCR.beefWellingtonPhases
        ),
        PracticeRitualModelCR(
            id: "bbq_ribs",
            title: "Protocol: Low-Intensity Collagen Transformation",
            trainingDomain: "Pork",
            imageName: "pork_shoulder_pulled",
            ritualDescription: "Long-duration, low-intensity thermal impact for deep collagen breakdown. Develops patience and precision in managing atmospheric humidity and indirect heat.",
            precisionLevel: "Developing",
            heatApplicationDuration: "4 hours",
            roastType: "Pork",
            heatControlPhases: HeatControlPhaseModelCR.bbqRibsPhases
        ),
        PracticeRitualModelCR(
            id: "spatchcock_chicken",
            title: "Protocol: Planar Decompression Poultry Thermal",
            trainingDomain: "Chicken",
            imageName: "chicken_thighs_crispy",
            ritualDescription: "Structural modification for improved surface area heat absorption. This scenario explores even thermal distribution through planar orientation.",
            precisionLevel: "Developing",
            heatApplicationDuration: "45 minutes",
            roastType: "Chicken",
            heatControlPhases: HeatControlPhaseModelCR.spatchcockChickenPhases
        ),
        PracticeRitualModelCR(
            id: "lamb_shanks",
            title: "Protocol: Submerged Indirect Thermal Degradation",
            trainingDomain: "Lamb",
            imageName: "lamb_shoulder_braised",
            ritualDescription: "Execute deep structural degradation protocols via submerged heat application. Focuses on long-form fiber separation and liquid-to-solid thermal exchange.",
            precisionLevel: "Developing",
            heatApplicationDuration: "3 hours",
            roastType: "Lamb",
            heatControlPhases: HeatControlPhaseModelCR.lambShanksPhases
        ),
        PracticeRitualModelCR(
            id: "tuna_tataki",
            title: "Protocol: Extreme Surface-Only Thermal Impact",
            trainingDomain: "Fish",
            imageName: "tuna_steak_rare",
            ritualDescription: "Managing extreme thermal gradients where only the external membrane is modified while the core remains in a stable, unheated state.",
            precisionLevel: "Developing",
            heatApplicationDuration: "20 minutes",
            roastType: "Fish",
            heatControlPhases: HeatControlPhaseModelCR.tunaTatakiPhases
        ),
        PracticeRitualModelCR(
            id: "prime_rib",
            title: "Protocol: Large-Scale Fiber Consistency (Beef)",
            trainingDomain: "Beef",
            imageName: "beef_well_done",
            ritualDescription: "Mastering thermal momentum in large biological structures. Focuses on edge-to-edge consistency through controlled timing and temperature management.",
            precisionLevel: "Precision",
            heatApplicationDuration: "3 hours",
            roastType: "Beef",
            heatControlPhases: HeatControlPhaseModelCR.primeRibPhases
        ),
        PracticeRitualModelCR(
            id: "pork_belly",
            title: "Protocol: Dual-Stage Lipid/Fiber Modification",
            trainingDomain: "Pork",
            imageName: "pork_chops_seared",
            ritualDescription: "Managing extreme fat-to-protein ratios under varying heat intensities. Focuses on simultaneous surface dehydration and internal fiber tenderization.",
            precisionLevel: "Precision",
            heatApplicationDuration: "3.5 hours",
            roastType: "Pork",
            heatControlPhases: HeatControlPhaseModelCR.porkBellyPhases
        ),
        PracticeRitualModelCR(
            id: "chicken_wings",
            title: "Protocol: Rapid Surface Dehydration (Poultry)",
            trainingDomain: "Chicken",
            imageName: "chicken_breast_grilled",
            ritualDescription: "Execute maximum surface modification without internal moisture loss. Develops skills in high-frequency heat application and moisture barrier management.",
            precisionLevel: "Foundation",
            heatApplicationDuration: "50 minutes",
            roastType: "Chicken",
            heatControlPhases: HeatControlPhaseModelCR.chickenWingsPhases
        ),
        PracticeRitualModelCR(
            id: "lamb_leg",
            title: "Protocol: Massive Structure Roasting Capability",
            trainingDomain: "Lamb",
            imageName: "lamb_leg_roasted",
            ritualDescription: "Execute heat application to complex, bone-in large format structures. Focuses on managing thermal penetration through dense muscle groups.",
            precisionLevel: "Developing",
            heatApplicationDuration: "2 hours",
            roastType: "Lamb",
            heatControlPhases: HeatControlPhaseModelCR.lambLegPhases
        ),
        PracticeRitualModelCR(
            id: "whole_fish",
            title: "Protocol: Integrative Aquatic Structure Heat",
            trainingDomain: "Fish",
            imageName: "white_fish_herbs",
            ritualDescription: "Managing heat application to intact biological structures with minimal surface barriers. Focuses on preserving structural integrity and delicate fiber cohesion.",
            precisionLevel: "Developing",
            heatApplicationDuration: "35 minutes",
            roastType: "Fish",
            heatControlPhases: HeatControlPhaseModelCR.wholeFishPhases
        ),
        PracticeRitualModelCR(
            id: "tomahawk_steak",
            title: "Protocol: Bone-Extended High-Intensity Impact",
            trainingDomain: "Beef",
            imageName: "beef_rare_cut",
            ritualDescription: "Managing heat distribution in structures with significant thermal-conducting extensions (bones). Focuses on high-intensity direct thermal modified states.",
            precisionLevel: "Precision",
            heatApplicationDuration: "40 minutes",
            roastType: "Beef",
            heatControlPhases: HeatControlPhaseModelCR.tomahawkSteakPhases
        ),
        PracticeRitualModelCR(
            id: "pulled_pork",
            title: "Protocol: Deep Tissue Fiber Separation (Pork)",
            trainingDomain: "Pork",
            imageName: "pork_shoulder_pulled",
            ritualDescription: "Transforming high-resistance fiber structures through extended low-intensity heat. Develops consistency in managing long-form thermal breakdown.",
            precisionLevel: "Developing",
            heatApplicationDuration: "8 hours",
            roastType: "Pork",
            heatControlPhases: HeatControlPhaseModelCR.pulledPorkPhases
        ),
        PracticeRitualModelCR(
            id: "duck_breast",
            title: "Protocol: Lipid Rendering & Surface Precision",
            trainingDomain: "Chicken",
            imageName: "chicken_thighs_crispy",
            ritualDescription: "Managing thick lipid layers and delicate protein fibers simultaneously. Focuses on fat rendering and precise surface temperature management.",
            precisionLevel: "Developing",
            heatApplicationDuration: "25 minutes",
            roastType: "Chicken",
            heatControlPhases: HeatControlPhaseModelCR.duckBreastPhases
        ),
        PracticeRitualModelCR(
            id: "lamb_lollipops",
            title: "Protocol: Rapid Segmented Fiber Impact",
            trainingDomain: "Lamb",
            imageName: "lamb_chops_rack",
            ritualDescription: "Execute rapid thermal modified states on small, isolated protein segments. Focuses on timing precision and avoiding thermal overshoot.",
            precisionLevel: "Foundation",
            heatApplicationDuration: "20 minutes",
            roastType: "Lamb",
            heatControlPhases: HeatControlPhaseModelCR.lambLollipopsPhases
        ),
        PracticeRitualModelCR(
            id: "lobster_tails",
            title: "Protocol: Controlled Low-Temp Poaching (Fish)",
            trainingDomain: "Fish",
            imageName: "shrimp_garlic_butter",
            ritualDescription: "Develop precision in managing low-temperature thermal exchange with highly sensitive biological structures. Focuses on achieving specific denaturation points without structural failure.",
            precisionLevel: "Developing",
            heatApplicationDuration: "25 minutes",
            roastType: "Fish",
            heatControlPhases: HeatControlPhaseModelCR.lobsterTailsPhases
        )
    ]
}

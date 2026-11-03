import Foundation

/// 界面文案（英文；本地化时替换实现即可）
enum BakeStrings {
    static let appName = "Bake Ratio"

    // MARK: 页签
    static let tabDough = "Dough"
    static let tabRecipes = "Recipes"
    static let tabSchedule = "Schedule"
    static let tabBakes = "Bakes"

    // MARK: 配料
    static let flour = "Flour"
    static let water = "Water"
    static let salt = "Salt"
    static let starter = "Starter"
    static let starterFlour = "Starter — flour"
    static let starterWater = "Starter — water"
    static let starterNote = "assumed 100% hydration"

    // MARK: 模式
    static let modeFlour = "Start from flour"
    static let modeTotal = "Start from dough weight"

    // MARK: 输入
    static let sectionSize = "Size"
    static let sectionRatio = "Ratios"
    static let sectionResult = "Your dough"
    static let sectionPresets = "Start from a style"
    static let flourWeight = "Flour"
    static let doughWeight = "Total dough"
    static let hydration = "Hydration"
    static let loaves = "Loaves"
    static let grams = "g"

    // MARK: 预设
    static let presetCountry = "Country loaf"
    static let presetCountryNote = "Open crumb, 75% water"
    static let presetBaguette = "Baguette"
    static let presetBaguetteNote = "Firmer dough, more starter"
    static let presetSandwich = "Sandwich"
    static let presetSandwichNote = "Soft, easy to slice"
    static let presetPizza = "Pizza"
    static let presetPizzaNote = "Stiff, for stretching"

    // MARK: 水温
    static let waterTempTitle = "Water temperature"
    static let waterTempSubtitle = "Work backwards from the dough temperature you want"
    static let desiredDoughTemp = "Dough target"
    static let flourTemp = "Flour temp"
    static let friction = "Mixer friction"
    static let waterNeeded = "Use water at"
    static let waterColder = "Colder than tap water — chill it or use ice."
    static let waterWarmer = "Warmer than tap water — warm it slightly."
    static let waterFine = "Within normal tap water range."

    // MARK: 结果卡
    static let total = "Total dough"
    static let perLoaf = "Per loaf"
    static let totalFlour = "Total flour (incl. starter)"
    static let totalWater = "Total water (incl. starter)"
    static let saveRecipe = "Save recipe"
    static let logBake = "Log this bake"
    static let logged = "Logged"

    // MARK: 配方
    static let recipes = "Recipes"
    static let noRecipes = "No saved recipes yet. Save the mix you are looking at, and it will appear here."
    static let recipeName = "Recipe name"
    static let load = "Use"
    static let delete = "Delete"
    static let done = "Done"
    static let saveCurrent = "Save current mix"
    static let useInCalculator = "Use in calculator"
    static let recipeNote = "Note"
    static let recipeNotePlaceholder = "Flour brand, timing, what to change next time"

    // MARK: 时间表
    static let timing = "Bulk fermentation"
    static let timingEstimate = "Estimated bulk ferment"
    static let timingNote = "A rough estimate from room temperature and starter amount. Judge the dough, not the clock — this is a guide, not an instruction."
    static let roomTemp = "Room temperature"
    static let planTitle = "Plan"
    static let startTime = "Start mixing at"
    static let startNow = "Now"
    static let folds = "Folds"
    static let coldRetard = "Cold retard overnight"
    static let retardHours = "Hours in the fridge"
    static let timelineTitle = "Timeline"
    static let nextUp = "Next up"
    static let stepDone = "Done"
    static let clearPlan = "Reset checks"

    static let stepMix = "Mix"
    static let stepMixNote = "Room at %d ℃, starter ready"
    static let stepRest = "Rest"
    static let stepRestNote = "Let the flour hydrate before adding salt"
    static let stepBulk = "Bulk fermentation"
    static let stepBulkNote = "Fold in the bowl until the dough feels strong"
    static let stepFoldNote = "Stretch and fold, then cover again"
    static let stepShape = "Shape"
    static let stepShapeNote = "Pre-shape, rest 20 min, final shape"
    static let stepRetard = "Into the fridge"
    static let stepRetardNote = "Covered, seam up, for the night"
    static let stepBake = "Bake"
    static let stepBakeNote = "Preheat at 250 ℃, 20 min lid on, 20 min off"
    static let stepCool = "Cool"
    static let stepCoolNote = "At least one hour before slicing"

    static func stepFold(_ n: Int) -> String { "Fold \(n)" }

    // MARK: 烘焙记录
    static let bakesTitle = "Bakes"
    static let noBakes = "Nothing logged yet. Use \"Log this bake\" on the Dough tab after a bake."
    static let score = "How it turned out"
    static let averageScore = "Average score"
    static let totalBakes = "Bakes logged"
    static let lastBake = "Last bake"
    static let summaryTitle = "Summary"

    // MARK: 说明
    static let about = "About"
    static let aboutWhatTitle = "What this app does"
    static let aboutWhat = "Bake Ratio converts a ratio into weights: choose hydration, salt and starter percentages, and it returns the grams for one dough — plus what that looks like per loaf. It also estimates a bulk fermentation window, turns your start time into a timeline, and works out what temperature the water needs to be."
    static let aboutPrivacyTitle = "Privacy"
    static let aboutPrivacy = "Everything you enter stays on this device. No account, no network connection, no analytics, no advertising. Deleting the app deletes your saved recipes and bakes."
    static let aboutDisclaimerTitle = "Disclaimer"
    static let aboutDisclaimer = "Bake Ratio performs arithmetic only. Fermentation times are rough estimates that depend on flour, starter strength and technique; they are not instructions and carry no guarantee. Always judge the dough itself."
    static let aboutDataTitle = "Your data"
    static let aboutData = "Recipes and bake records are stored in a single file inside the app's own storage. There is no export feature and no cloud sync."
    static let aboutSettings = "Settings"
    static let aboutVersion = "Version 1.1"

    // MARK: 设置
    static let settings = "Settings"
    static let showStarterSplit = "Show starter flour and water"
    static let loafTarget = "Target loaf weight"
    static let unitsNote = "All weights are in grams."
}

import Foundation

/// 界面文案（英文本，后续加语言时替换实现即可）
enum BakeStrings {
    static let appName = "Bake Ratio"

    // 配料
    static let flour = "Flour"
    static let water = "Water"
    static let salt = "Salt"
    static let starter = "Starter"
    static let starterFlour = "Starter — flour"
    static let starterWater = "Starter — water"
    static let starterNote = "assumed 100% hydration"

    // 模式
    static let modeFlour = "Start from flour"
    static let modeTotal = "Start from dough weight"

    // 输入
    static let sectionSize = "Size"
    static let sectionRatio = "Ratios"
    static let sectionResult = "Your dough"
    static let flourWeight = "Flour"
    static let doughWeight = "Total dough"
    static let hydration = "Hydration"
    static let loaves = "Loaves"
    static let grams = "g"

    // 结果卡
    static let total = "Total dough"
    static let perLoaf = "Per loaf"
    static let totalFlour = "Total flour (incl. starter)"
    static let totalWater = "Total water (incl. starter)"
    static let saveRecipe = "Save recipe"
    static let logBake = "Log this bake"

    // 配方库
    static let recipes = "Recipes"
    static let noRecipes = "No saved recipes yet."
    static let recipeName = "Recipe name"
    static let load = "Use"
    static let delete = "Delete"
    static let done = "Done"

    // 计时
    static let timing = "Bulk fermentation"
    static let timingEstimate = "Estimated bulk ferment"
    static let timingNote = "A rough estimate from room temperature and starter amount. Judge the dough, not the clock — this is a guide, not an instruction."
    static let startTimer = "Start timer"
    static let stopTimer = "Stop"
    static let timerRunning = "Time remaining"
    static let roomTemp = "Room temperature"

    // 说明
    static let about = "About"
    static let aboutWhatTitle = "What this app does"
    static let aboutWhat = "Bake Ratio converts a ratio into weights: choose hydration, salt and starter percentages, and it returns the grams for one dough — plus what that looks like per loaf. It also estimates a bulk fermentation window from room temperature and starter amount."
    static let aboutPrivacyTitle = "Privacy"
    static let aboutPrivacy = "Everything you enter stays on this device. No account, no network connection, no analytics, no advertising. Deleting the app deletes your saved recipes and bakes."
    static let aboutDisclaimerTitle = "Disclaimer"
    static let aboutDisclaimer = "Bake Ratio performs arithmetic only. Fermentation times are rough estimates that depend on flour, starter strength and technique; they are not instructions and carry no guarantee. Always judge the dough itself."
    static let aboutDataTitle = "Your data"
    static let aboutData = "Recipes and bake records are stored in a single file inside the app's own storage. There is no export feature and no cloud sync."
    static let aboutSettings = "Settings"
    static let aboutVersion = "Version 1.0"
}

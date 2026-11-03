# Bake Ratio

Convert a dough ratio into grams. Pick flour weight (or target dough weight), set hydration,
salt and starter percentages, and Bake Ratio returns every ingredient in grams, the total, and
the weight per loaf — plus a rough bulk-fermentation window based on room temperature.

Pure SwiftUI, iOS 17+, **fully offline**: no account, no network requests, no third-party SDKs,
no advertising, no in-app purchases.

## What is on screen

A single page (no tab bar):

1. **Where to start** — "Start from flour" or "Start from dough weight"
2. **Size** — flour/total grams and number of loaves
3. **Ratios** — hydration (50–100%), salt (0.5–3.5%), starter (5–40%)
4. **Your dough** — ingredient list with grams and baker's percentages; starter split into
   flour and water (assumed 100% hydration, stated on screen)
5. **Result card** — total dough, per-loaf weight, true total flour and total water including
   the starter
6. **Bulk fermentation** (via ••• menu) — estimate from room temperature and starter amount,
   with a countdown timer
7. **Recipes** (via ••• menu) — save the current mix, load it later, delete; bake log included

## Structure

```
BakeRatio.xcodeproj/            hand-maintained pbxproj
BakeRatio/
  BakeRatioApp.swift            @main, BakeAppState, BakePalette
  Models/
    BakeFormula.swift           the arithmetic + fermentation estimate
    BakeIngredient.swift        ingredient lines for display
    BakeRecipe.swift            saved recipe + bake log entry types
    BakeStore.swift             JSON persistence in the app sandbox
    BakeMix.swift               the editable mix and its conversions
  Support/
    BakeSettings.swift          room temperature, display options
    BakeStrings.swift           all user-facing text
    BakeNumbers.swift           gram/percent/time formatting
  Views/
    BakeRootView.swift          navigation shell + menu
    BakeCalculatorView.swift    the whole calculator page (incl. result card)
    BakeInputRow.swift          slider / stepper / gram rows
    BakeRecipeSheet.swift       saved recipes + bake log
    BakeTimingSheet.swift       fermentation estimate + countdown
    BakeAboutView.swift         about, settings, privacy, disclaimer
  Resources/
    Assets.xcassets/            AppIcon (1024, no alpha)
codemagic.yaml                  compile-check / ios-build / demo-capture
support.html, privacy.html      App Store support + privacy pages
tools/                          icon generator, self-check
```

## Before the first signed build

Replace `com.example.bakeratio` in three places:

1. `BakeRatio.xcodeproj/project.pbxproj` (Debug and Release)
2. `codemagic.yaml` → `ios_signing.bundle_identifier`
3. `codemagic.yaml` → `app-store-connect fetch-signing-files`

## Build (no Mac needed)

1. Push the **contents** of this folder to a GitHub repository
2. Codemagic → Add application → Native iOS → `codemagic.yaml`
3. Settings → Integrations → Developer Portal → add the App Store Connect API key
4. Settings → Environment variables → group with `APP_STORE_CONNECT_PRIVATE_KEY`
5. Run `compile-check`, then `ios-build`

## Self-check

```
python3 tools/selfcheck.py
```

## App Review Notes (write fresh for this submission)

This app is a **single-page calculator**. There is no tab bar: everything is on the first
screen, with Recipes, Fermentation and About reachable from the ••• menu in the top right.
No account, no permissions, no network.

(require 'dash)

(defun kg-lbs (kg)
  (/ kg 0.45359237))

(defun l-gal (l)
  (/ l 3.78541178))

(defun lbs-kg (lbs)
  (* lbs 0.45359237))

(defun gal-l (gal)
  (* gal 3.78541178))

(defun strike-water-temp (ratio infusion-temp grain-temp)
  "Calculate the strike water temperature given the
   liters water/kilograms grain ratio, the desired infusion
   temperature and the grain temperature"
  (+ (* (/ 0.41 ratio) (- infusion-temp grain-temp)) infusion-temp))

(defun infusion-volume (infusion-temp mash-temp grain-weight water-volume addition-temp)
  "Calculate the amount of water at temperature ADDITION-TEMP
   necessary to add to a mash of GRAIN-WIGHT (kg) and WATER-VOLUME (l)
   currently at MASH-TEMP (C) in order to bring it up to INFUSION-TEMP (C)"
  (/ (* (- infusion-temp mash-temp) (+ (* 0.41 grain-weight) water-volume)) (- addition-temp infusion-temp)))

(defun infusion-volume-boil (infusion-temp mash-temp grain-weight water-volume)
  "Calculate the amount of boiling water necessary to add to a
   mash of GRAIN-WAIGHT (kg) and WATER-VOLUME (l) currently at
   MASH-TEMP (C) in order to bring it up to INFUSION-TEMP (C)"
  (infusion-volume infusion-temp mash-temp grain-weight water-volume 100))

(defun gravity-points (gravity)
  "Given a GRAVITY like 1.050, get the number of 'gravity points'
   (e.g. 50)"
  (* 1000 (- gravity 1)))

(defun wort-gravity (vol weight ppg)
  "Given WEIGHT (lbs) amount of fermentable with gravity points PPG,
   calculate the specific gravity in a wort of VOL gallons"
  (+ 1 (/ (* (/ weight vol) ppg) 1000.0)))

(defun wort-gravity-metric (vol weight ppg)
  "Given WEIGHT (kg) amount of fermentable with gravity points PPG,
   calculate the specific gravity in a wort of VOL liters"
  (wort-gravity (l-gal vol) (kg-lbs weight) ppg))

(defun extract-weight-for-og (vol og ppg)
  "Calculate the amount of extract with PPG ppg (gravity points per
   lb per gallon) needed for VOL gallons of wort at original gravity OG"
  (let ((points (* (gravity-points og) vol)))
    (/ points ppg)))

(defun dme-amount-for-og (vol og)
  "Given the wort volume VOL in gallons, and an original gravity OG,
   calculate the necessary amount of DME in lbs"
  (extract-weight-for-og vol og 42))

(defun lme-amount-for-og (vol og)
  "Given the wort volume VOL in gallons, and an original gravity OG,
   calculate the necessary amount of LME in lbs"
  (extract-weight-for-og vol og 36))

(defun extract-kg-for-og (vol og ppg)
  "Calculate the weight in kg of extract to reach the desired OG in
   a wort of VOL litres."
  (lbs-kg (extract-weight-for-og (l-gal vol) og ppg)))

(defun dme-kg-for-og (vol og)
  (extract-kg-for-og vol og 42))

(defun lme-kg-for-og (vol og)
  (extract-kg-for-og vol og 36))

(defun abv (og fg)
  (* (- og fg) 131.25))

(defvar sucrose-ppg 46)

(defun extraction-efficiency (grain-weight wort-volume gravity)
  (/ (* (gravity-points gravity) wort-volume) grain-weight))

(defun mash-efficiency (grain-weight wort-volume gravity fgdb)
  (/ (extraction-efficiency grain-weight wort-volume gravity) (* fgdb sucrose-ppg)))

(defun extraction-efficiency-metric (grain-weight wort-volume gravity)
  (extraction-efficiency (kg-lbs grain-weight) (l-gal wort-volume) gravity))

(defun mash-efficiency-metric (grain-weight wort-volume gravity fgdb)
  (mash-efficiency (kg-lbs grain-weight) (l-gal wort-volume) gravity fgdb))

(defun required-grain-weights (wort-volume gravity grains)
  "Calculates required weight of individual grains based on a list
   of grains where each item is a list of the grain's percentage in
   the recipe, its fgdb, and expected efficiency, e.g.:
   ((0.1 0.7 0.75)  ;; CaraPils
    (0.1 0.75 0.75) ;; Light Crystal 10L
    (0.8 0.8 0.75)  ;; Two-row lager malt
    )"
  (let ((points (* (gravity-points gravity) wort-volume)))
    (-map (lambda (grain)
            (/ (* points (car grain))
               (* (car (cdr grain)) (car (cddr grain)) sucrose-ppg))) grains)))

(defun required-grain-weights-metric (wort-volume gravity grains)
  (-map 'lbs-kg (required-grain-weights (l-gal wort-volume) gravity grains)))

;; (required-grain-weights 5 1.050 '((0.74 0.78 0.75) (0.26 0.75 0.75)))
;; (required-grain-weights-metric 18.92 1.050 '((0.74 0.78 0.75) (0.26 0.75 0.75)))

(defun boil-cold (temp volume cold-temp)
  "To create VOLUME liters of TEMP C water, use this many liters
   of boiling water, and this many liters of cold water"
  (let ((boiling (/ (- (* temp volume) cold-temp) 100)))
    (list (cons (- volume boiling) cold-temp) (cons boiling 100))))

(defun wort-points (gravity volume)
  (* (gravity-points gravity) volume))

(defun wort-points-metric (gravity volume)
  (wort-points gravity (l-gal volume)))

(defun wort-volume-at-gravity (gravity volume desired-gravity)
  (/ (wort-points gravity volume) (gravity-points desired-gravity)))

(defun mash-schedule (grain-weight grain-temp start-ratio steps)
  (let ((strike-temp (strike-water-temp start-ratio (car steps) grain-temp))
        (mash-temp (car steps))
        (water-volume (* grain-weight start-ratio)))
    (-flatten (cons (boil-cold strike-temp water-volume 10.4) (-map (lambda (infusion-temp)
                                                                      (cons (infusion-volume-boil infusion-temp mash-temp grain-weight water-volume) 100)) (cdr steps))))))

(defun final-mash-volume (grain-weight grain-temp start-ratio steps)
  (-reduce-from (lambda (sum pair) (+ sum (car pair)))
                0 (mash-schedule grain-weight grain-temp start-ratio steps)))

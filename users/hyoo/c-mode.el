(defun my-c-mode-common-hook ()
  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (c-set-offset 'substatement-open 0) ;; if (cond) '\n' {
  ;; other customizations can go here

  ;; (setq c++-tab-always-indent nil)
  (setq c-basic-offset 2)                  ;; Default is 2
  (setq c-indent-level 2)                  ;; Default is 2

  ;;(setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
  ;;(setq tab-width 4)
  ;;(setq indent-tabs-mode t)  ; use spaces only if nil
  (setq indent-tabs-mode nil))

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))


(use-package cpputils-cmake :ensure)
;; (setq cppcm-build-dirname "/home/hyoo/build")
(use-package flycheck-pos-tip :ensure t)
(global-flycheck-mode)


(add-hook 'c-mode-common-hook
          (lambda ()
            (if (derived-mode-p 'c-mode 'c++-mode)
                (cppcm-reload-all)
              )))

;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (setq flycheck-gcc-include-path '("/home/hyoo/repo/cpp/lib" "/home/hyoo/repo/cpp/td/equitiesCommon/src" "/home/hyoo/repo/cpp/td/trading/src"
;;                                               "/home/hyoo/repo/cpp/td/jvcommon" "/home/hyoo/jv_lib/tbb/tbb43_20150611oss/include" "/home/hyoo/jv_lib/gtest/1.7.0/include" "/home/hyoo/jv_lib/gmock/1.7.0/include" "/home/hyoo/jv_lib/zlib/1.2.8/include"
;;                                               "/home/hyoo/jv_lib/hdf5/1.8.15-patch1/include" "/home/hyoo/jv_lib/szip/2.1/include"
;;                                               "/home/hyoo/jv_lib/amd-libm/3.1-lin64/include" "/home/hyoo/jv_lib/acml/6.1.0.31/gfortran64/include"
;;                                               "/home/hyoo/jv_lib/arma/5.400.2-acml/include" "/home/hyoo/jv_lib/sqlite/3.08.11.01/include" "/home/hyoo/jv_lib/boost/1_59_0/include" "/home/hyoo/jv_lib/protobuf/2.6.1/include" "/home/hyoo/jv_lib/gsl/2_1/include" "/home/hyoo/jv_lib/curl/7.49.1/include" "/home/hyoo/jv_lib/thrift/0.9.3/include"
;;                                               "/home/hyoo/jv_lib/nlopt/2.4.2/include" "/home/hyoo/jv_delivery/debug/include"
;;                                               "/home/hyoo/repo/cpp/lib/jv/jv/utils" "/home/hyoo/jv_lib/nlopt/2.4.2/include")
;; )))

;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (setq flycheck-clang-include-path '("/home/hyoo/repo/cpp/" "/home/hyoo/repo/cpp/lib/jv/jvi")
;; )))


;; (defun setup-flycheck-gcc-project-path ()
;;   (let ((root (ignore-errors (projectile-project-root))))
;;     (when root
;;       (add-to-list
;;        (make-variable-buffer-local 'flycheck-gcc-include-path)
;;        root))))

;; (add-hook 'c-mode-common-hook 'setup-flycheck-gcc-project-path)

;; (add-hook 'c-mode-common-hook (lambda () (set flycheck-clang-include-path (mapcar (lambda (p) (expand-file-name p (projectile-project-root)) my-relative-include-paths)

;; (setq flycheck-clang-include-path '("/home/hyoo/repo/cpp/lib/jv/utils/" "/home/hyoo/jv_lib/hdf5/1.8.15-patch1/include" "/home/hyoo/jv_lib/hdf5/1.8.15-patch1/include"))
;; (setq flycheck-clang-include-path '("/home/hyoo/repo/cpp/lib/jv/utils/" "/home/hyoo/jv_lib/hdf5/1.8.15-patch1/include" "/home/hyoo/jv_lib/hdf5/1.8.15-patch1/include"))
;; (add-to-list 'flycheck-clang-include-path '("/home/hyoo/repo/cpp/lib/jv/utils/" "/home/hyoo/jv_lib/hdf5/1.8.15-patch1/include"))

;; (setq flycheck-gcc-include-path '("/home/hyoo/repo/cpp/lib/jv/utils/" "/home/hyoo/jv_lib/hdf5/1.8.15-patch1/include" "/home/hyoo/jv_lib/hdf5/1.8.15-patch1/include"))

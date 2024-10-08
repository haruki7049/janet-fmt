(import spork/fmt)
(import spork/argparse)

(def- default-config ".janet-format.jdn")

(defn- main
  [&]

  (def ap
    (argparse/argparse
      "Format Janet source code in files and write output to those files."

      :default
      {:kind :accumulate
       :help "Files to format"}

      "files"
      {:short "f"
       :help "Format a list of source files."
       :kind :flag}

      "output"
      {:short "o"
       :kind :option
       :help "Where to direct output to. By default, output goes to stdout."}

      "input"
      {:short "i"
       :kind :option
       :help "Read from an input file"}

      "config"
      {:short "c"
       :kind :option
       :help "Which configuration file to read"
       :default default-config}

      "no-config"
      {:short "n"
       :kind :flag
       :help "Avoid loading any configuration"}))

  # Break on help text
  (unless ap (break))

  (unless (ap "no-config")
    (def config (ap "config"))
    (def [exists contents] (protect (slurp config)))
    (if exists
      (setdyn fmt/*user-indent-2-forms* (parse contents))
      (when (not= config default-config)
        (eprintf "Configuration file '%s' does not exist" config))))

  (if (or (ap "files") (ap :default))
    (each file (ap :default)
      (eprint "formatting " file "...")
      (fmt/format-file file))
    (if-let [ofile (ap "output")]
      (with [output (file/open ofile :wb)]
        (if-let [ifile (ap "input")]
          (xprin output (fmt/format (slurp ifile)))
          (xprin output (fmt/format (file/read stdin :all)))))
      (if-let [ifile (ap "input")]
        (prin (fmt/format (slurp ifile)))
        (prin (fmt/format (file/read stdin :all)))))))

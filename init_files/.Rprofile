options(browserNLdisabled = TRUE,
        stringsAsFactors = FALSE,
        useFancyQuotes = FALSE,
        warnPartialMatchArgs = TRUE,
        warnPartialMatchAttr = TRUE,
        warnPartialMatchDollar = TRUE,
        browser = "/Applications/Firefox.app/Contents/MacOS/firefox",
        editor = "/opt/R/arm64/bin/emacs",
        menu.graphics = FALSE,
        repos =
            local({
                r <- getOption("repos")
                r["CRAN"] <- "https://cloud.r-project.org/"
                r["BioCsoft"] <- "%bm/packages/%v/bioc"
                r["BioCann"] <- "%bm/packages/%v/data/annotation"
                r["BioCexp"] <- "%bm/packages/%v/data/experiment"
                if(getRversion() < "4.3.0")
                    tools:::.expand_BioC_repository_URLs(r)
                else utils:::.expand_BioC_repository_URLs(r)
            }),
        pkgType = "source",
        install.packages.compile.from.source = "always",
        Ncpus = 4L)

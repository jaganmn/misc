library("tikzDevice")
library("png")

set.seed(101)
dd <- data.frame(x = rnorm(1e5), y = rnorm(1e5))

tikz("foo.tex", width = 5, height = 5, standAlone = TRUE)
plot(y ~ x, data = dd,
     xlim = c(-5, 5), ylim = c(-5, 5),
     col = "#00000033")
dev.off() # 12M
# system("pdflatex foo.tex") # TeX capacity exceeded, sorry

png("bar.png", bg = "transparent", width = 5, height = 5, units = "in", res = 300)
plot(y ~ x, data = dd,
     ann = FALSE, axes = FALSE,
     xlim = c(-5, 5), ylim = c(-5, 5),
     col = "#00000033")
dev.off()
bar <- readPNG("bar.png", native = TRUE)

tikz("bar.tex", width = 5, height = 5, standAlone = TRUE)
plot(y ~ x, data = dd, type = "n",
     xlim = c(-5, 5), ylim = c(-5, 5))
usr <- par("usr")
mxy <- par("mai") * (par("cxy") / par("cin"))[2:1]
rasterImage(bar, interpolate = FALSE,
            xleft = usr[1L] - mxy[2L],
            xright = usr[2L] + mxy[4L],
            ybottom = usr[3L] - mxy[1L],
            ytop = usr[4L] + mxy[3L])
dev.off() # 3.7K
system("pdflatex bar.tex") # OK

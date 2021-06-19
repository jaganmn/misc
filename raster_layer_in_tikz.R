library("tikzDevice")
library("png")

set.seed(101)
dd <- data.frame(x = rnorm(1e5), y = rnorm(1e5))

w <- h <- 5
xlim <- ylim <- c(-5, 5)
col <- "#00000033"

## Brute force attempt to plot everything on a `tikz` device
tikz("foo.tex", width = w, height = h, standAlone = TRUE)
plot(y ~ x, data = dd, xlim = xlim, ylim = ylim, col = col)
dev.off() # 12M
# system("pdflatex foo.tex") # TeX capacity exceeded, sorry

## Create raster layer containing just points
png("bar.png", width = w, height = h, units = "in",
    res = 300, bg = "transparent")
plot(y ~ x, data = dd, xlim = xlim, ylim = ylim, col = col,
     ann = FALSE, axes = FALSE)
dev.off()

## Read raster layer into R as raster array
bar <- readPNG("bar.png", native = TRUE)

## Embed raster layer in `tikz` plot containing just axes
tikz("bar.tex", width = w, height = h, standAlone = TRUE)
plot(y ~ x, data = dd, xlim = xlim, ylim = ylim, type = "n")
usr <- par("usr")
mxy <- par("mai") * (par("cxy") / par("cin"))[2:1]
rasterImage(bar, interpolate = FALSE,
            ## Corners of device in user coordinates
            xleft = usr[1] - mxy[2],
            xright = usr[2] + mxy[4],
            ybottom = usr[3] - mxy[1],
            ytop = usr[4] + mxy[3])
dev.off() # 3.7K
system("pdflatex bar.tex") # OK

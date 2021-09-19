jpeg("mgp3_bug.jpeg")

par(mar = c(5, 1, 5, 1))
plot.new()
plot.window(xlim = c(0, 1), ylim = c(0, 1))
box(lty = 3)

## 'axis' puts line and labels in right place when 'mgp[3]' is integer
mgp_bottom <- c(0, 2.5, 1) # first element is arbitrary here
axis(side = 1, mgp = mgp_bottom)
mtext(c("labels", "line"), side = 1, line = mgp_bottom[2:3])

## 'axis' puts line in right place when 'mgp[3]' is noninteger,
## but apparently not labels
mgp_top <- mgp_bottom - c(0, 0, 1e-3)
axis(side = 3, mgp = mgp_top)
mtext(c("labels", "line"), side = 3, line = mgp_top[2:3])
mtext("LABELS", side = 3, line = mgp_top[2] + (mgp_top[3] %% 1))

dev.off()

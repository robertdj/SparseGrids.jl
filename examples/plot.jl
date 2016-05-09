using Deldir

N = 10
x = rand(N)
y = rand(N)

D = deldir(x, y)

Dx, Dy = delaunayedges(D)
Vx, Vy = voronoiedges(D)


using Winston

plot(D.summary[:x], D.summary[:y], "o")
oplot(Vx, Vy, "r--")
oplot(Dx, Dy)

xmin = min( minimum(D.vorsgs[:x1]), minimum(D.vorsgs[:x2]) )
xmax = max( maximum(D.vorsgs[:x1]), maximum(D.vorsgs[:x2]) )
xlim(xmin, xmax)

ymin = min( minimum(D.vorsgs[:y1]), minimum(D.vorsgs[:y2]) )
ymax = max( maximum(D.vorsgs[:y1]), maximum(D.vorsgs[:y2]) )
ylim(ymin, ymax)


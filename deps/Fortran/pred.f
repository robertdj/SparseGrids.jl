C Output from Public domain Ratfor, version 1.0
      subroutine pred(kpr,i,j,nadj,madj,ntot,nerror)
      implicit double precision(a-h,o-z)
      dimension nadj(-3:ntot,0:madj)
      nerror = -1
      n = nadj(i,0)
      if(n.eq.0)then
      nerror = 5
      return
      endif
      do23002 k = 1,n 
      if(j.eq.nadj(i,k))then
      km = k-1
      if(km.lt.1)then
      km = n
      endif
      kpr = nadj(i,km)
      return
      endif
23002 continue
23003 continue
      nerror = 6
      return
      end

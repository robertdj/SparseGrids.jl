C Output from Public domain Ratfor, version 1.0
      subroutine delet1(i,j,nadj,madj,ntot)
      implicit double precision(a-h,o-z)
      dimension nadj(-3:ntot,0:madj)
      n = nadj(i,0)
      do23000 k = 1,n 
      if(nadj(i,k).eq.j)then
      do23004 kk = k,n-1 
      nadj(i,kk) = nadj(i,kk+1) 
23004 continue
23005 continue
      nadj(i,n) = -99
      nadj(i,0) = n-1
      return
      endif
23000 continue
23001 continue
      end

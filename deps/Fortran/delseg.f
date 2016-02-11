C Output from Public domain Ratfor, version 1.0
      subroutine delseg(delsgs,ndel,nadj,madj,npd,x,y,ntot,ind,nerror)
      implicit double precision(a-h,o-z)
      logical value
      integer tdel
      dimension nadj(-3:ntot,0:madj), x(-3:ntot), y(-3:ntot)
      dimension delsgs(6,ndel), ind(npd)
      npd = ntot-4
      kseg = 0
      do23000 i1 = 2,npd 
      i = ind(i1)
      do23002 j1 = 1,i1-1 
      j = ind(j1)
      call adjchk(i,j,value,nadj,madj,ntot,nerror)
      if(nerror.gt.0)then
      return
      endif
      if(value)then
      kseg = kseg+1
      if(kseg .gt. ndel)then
      nerror = 14
      return
      endif
      delsgs(1,kseg) = x(i)
      delsgs(2,kseg) = y(i)
      delsgs(3,kseg) = x(j)
      delsgs(4,kseg) = y(j)
      delsgs(5,kseg) = i1
      delsgs(6,kseg) = j1
      endif
23002 continue
23003 continue
23000 continue
23001 continue
      ndel = kseg
      return
      end

C Output from Public domain Ratfor, version 1.0
      subroutine dirseg(dirsgs,ndir,nadj,madj,npd,x,y,ntot,rw,eps,ind,ne
     *rror)
      implicit double precision(a-h,o-z)
      logical collin, adjace, intfnd, bptab, bptcd, goferit, rwu
      dimension nadj(-3:ntot,0:madj), x(-3:ntot), y(-3:ntot)
      dimension dirsgs(8,ndir), rw(4), ind(npd)
      nerror = -1
      xmin = rw(1)
      xmax = rw(2)
      ymin = rw(3)
      ymax = rw(4)
      a = xmax-xmin
      b = ymax-ymin
      c = sqrt(a*a+b*b)
      npd = ntot-4
      nstt = npd+1
      i = nstt
      x(i) = xmin-c
      y(i) = ymin-c
      i = i+1
      x(i) = xmax+c
      y(i) = ymin-c
      i = i+1
      x(i) = xmax+c
      y(i) = ymax+c
      i = i+1
      x(i) = xmin-c
      y(i) = ymax+c
      do23000 j = nstt,ntot 
      call addpt(j,nadj,madj,x,y,ntot,eps,nerror)
      if(nerror .gt. 0)then
      return
      endif
23000 continue
23001 continue
      kseg = 0
      do23004 i1 = 2,npd 
      i = ind(i1)
      do23006 j1 = 1,i1-1 
      j = ind(j1)
      call adjchk(i,j,adjace,nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      if(adjace)then
      call pred(k,i,j,nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      call circen(i,k,j,a,b,x,y,ntot,eps,collin,nerror)
      if(nerror .gt. 0)then
      return
      endif
      if(collin)then
      nerror = 12
      return
      endif
      call succ(l,i,j,nadj,madj,ntot,nerror)
      if(nerror .gt. 0)then
      return
      endif
      call circen(i,j,l,c,d,x,y,ntot,eps,collin,nerror)
      if(nerror .gt. 0)then
      return
      endif
      if(collin)then
      nerror = 12
      return
      endif
      xi = x(i)
      xj = x(j)
      yi = y(i)
      yj = y(j)
      if(yi.ne.yj)then
      slope = (xi - xj)/(yj - yi)
      rwu = .true.
      else
      slope = 0.d0
      rwu = .false.
      endif
      call dldins(a,b,slope,rwu,ai,bi,rw,intfnd,bptab)
      if(.not.intfnd)then
      nerror = 16
      return
      endif
      call dldins(c,d,slope,rwu,ci,di,rw,intfnd,bptcd)
      if(.not.intfnd)then
      nerror = 16
      return
      endif
      goferit = .false.
      if(bptab .and. bptcd)then
      xm = 0.5*(ai+ci)
      ym = 0.5*(bi+di)
      if(xmin.lt.xm.and.xm.lt.xmax.and.ymin.lt.ym.and.ym.lt.ymax)then
      goferit = .true.
      endif
      endif
      if((.not.bptab).or.(.not.bptcd))then
      goferit = .true.
      endif
      if(goferit)then
      kseg = kseg + 1
      if(kseg .gt. ndir)then
      nerror = 15
      return
      endif
      dirsgs(1,kseg) = ai
      dirsgs(2,kseg) = bi
      dirsgs(3,kseg) = ci
      dirsgs(4,kseg) = di
      dirsgs(5,kseg) = i1
      dirsgs(6,kseg) = j1
      if(bptab)then
      dirsgs(7,kseg) = 1.d0
      else
      dirsgs(7,kseg) = 0.d0
      endif
      if(bptcd)then
      dirsgs(8,kseg) = 1.d0
      else
      dirsgs(8,kseg) = 0.d0
      endif
      endif
      endif
23006 continue
23007 continue
23004 continue
23005 continue
      ndir = kseg
      return
      end

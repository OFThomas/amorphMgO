
*************************************************************
* KEITH MCKENNA 2016
*************************************************************

      program Triple
	
	implicit none

c	declarations
	real :: n1, n2, n3
	integer :: na,nb	
	integer :: i,j	
	integer :: atoms, atomscrys	
	real :: x,y
	real :: a1x,a1y, b1x, b1y
	real :: a2x,a2y, b2x, b2y
	real :: a3x,a3y, b3x, b3y	
	real :: gb1x,gb1y
	real :: gb2x,gb2y
	real :: gb3x,gb3y		
	real :: Ox,Oy, Mgx, Mgy
	real :: xpos,ypos,xmin,xmax,ymin,ymax
	integer :: namin,namax
        integer :: nbmin,nbmax
	real :: a
	real :: l,delx,dely
	real :: oneoversqrttwo
	integer Nmax
	parameter ( Nmax=90000)
	character*2 Id(Nmax)
	real :: Xc(Nmax), Yc(Nmax), Zc(Nmax)
	integer :: C(Nmax)
	logical :: notruncate,closecheck
	real :: dist,xx,yy,zz
	real :: tol
	real :: Deltax,Deltay
	logical :: togglecryst2
	
c	read in triple junction triangle specification
c	note that n2+n3 > n1 is required
c	also n2+n3 not too large
c	read(*,*) n1,n2,n3
	n1=4.5
	n2=4
	n3=4

c	toggle Mg/O for crystal 2
	togglecryst2=.TRUE.

c	shift of crystals as frac of a
	Deltax=0.5d0
	Deltay=0.4d0
	
	a=4.212d0

c	number of layers in b directions (perp to centre)	
c         to generate core region
c          nbmin=-5
c         nbmax=-1
                
c         to generate hollow core
          nbmin=2
	  nbmax=20
c	nbmin=-5
c	number of layers in a directions (tangent to perp)	
	namin=-30
	namax=30

c	whether to cut crystals at GBs	
	notruncate=.false.
	
c	whether to remove atoms too close
	closecheck=.true.	
	tol=1.6d0
	
c	calculate position of third oxygen	
	x=(real((n1**2)+(n2**2)-(n3**2)))/(2.0d0*real(n1))
	y=sqrt(real((n2**2))-x**2.0d0)
	
c	DEFINE BASIS VECTORS
c	crystal 1
	a1x=1.0
	a1y=0.0
	b1x=0.5
	b1y=-0.5	

c	crystal 2	
	l=sqrt((x**2.0d0)+(y**2.0d0))
	
	a2x=x/l
	a2y=y/l
	
c	rotate and scale to get vector b
	oneoversqrttwo=1/sqrt(2.0d0)
	b2x=oneoversqrttwo*a2x-oneoversqrttwo*a2y
	b2y=+1.0d0*oneoversqrttwo*a2x+oneoversqrttwo*a2y
	b2x=b2x*oneoversqrttwo
	b2y=b2y*oneoversqrttwo

c	crystal 3
	delx=x-n1
	dely=y
	l=sqrt((delx**2.0d0)+(dely**2.0d0))
	
	a3x=delx/l
	a3y=dely/l
	
c	rotate and scale to get vector b
	oneoversqrttwo=1/sqrt(2.0d0)
	b3x=oneoversqrttwo*a3x+oneoversqrttwo*a3y
	b3y=-1.0d0*oneoversqrttwo*a3x+oneoversqrttwo*a3y
	b3x=b3x*oneoversqrttwo
	b3y=b3y*oneoversqrttwo


c	DEFINE GRAIN BOUNDARIES
c	GB crystal 1-2
	gb1x=(a1x+a2x)*(-1.0d0)
	gb1y=(a1y+a2y)*(-1.0d0)
	
c	GB crystal 2-3
	gb2x=(a2x+a3x)
	gb2y=(a2y+a3y)

c	GB crystal 3-1
	gb3x=((-1.0d0)*a1x+a3x)*(-1.0d0)
	gb3y=((-1.0d0)*a1y+a3y)*(-1.0d0)
	


c	GENERATE CRYSTALS	

	atoms=0
	
c	crystal 1
	Ox=0.0
	Oy=0.0
	
	Mgx=0.5*a1x
	Mgy=0.5*a1y

	do i=namin,namax
	  do j=nbmin,nbmax
	  
c       ensure atoms within defined grains	  

c	crystal 1 boundaries     
c     	xmin=gb1x*y/gb1y
c	xmax=((a1x*n1))*a)-((gb3x*(((a1y*n1))*a))/gb3y)+gb3x*y/gb3y

	    xmin=(gb1x*(Oy+(a1y*i+b1y*j))*a)/gb1y	 
  	    xmax=(((a1x*n1))*a)-((gb3x*(((a1y*n1))*a))/gb3y)
     c	    +(gb3x*(Oy+(a1y*i+b1y*j))*a)/gb3y
	    xpos=(Ox+(a1x*i+b1x*j))*a
	    
	    if(((xpos.ge.xmin).AND.(xpos.le.xmax)).OR.notruncate) then
c	    write(*,*) 'O1  ', (Ox+(a1x*i+b1x*j))*a,
c     c	    (Oy+(a1y*i+b1y*j))*a, 0.0
     
     	    atoms=atoms+1
	    Id(atoms)='2 '
     	    Xc(atoms)=(Ox+(a1x*i+b1x*j))*a
	    Yc(atoms)=(Oy+(a1y*i+b1y*j))*a -(Deltay*a)
	    Zc(atoms)=0.0
	    C(atoms)=1

     	    atoms=atoms+1
	    Id(atoms)='1 '
     	    Xc(atoms)=(Ox+(a1x*i+b1x*j))*a
	    Yc(atoms)=(Oy+(a1y*i+b1y*j))*a -(Deltay*a)
	    Zc(atoms)=a/2.0d0
	    C(atoms)=1
     	    endif

	    xmin=(gb1x*(Mgy+(a1y*i+b1y*j))*a)/gb1y
  	    xmax=(((a1x*n1))*a)-((gb3x*(((a1y*n1))*a))/gb3y)
     c	    +(gb3x*(Mgy+(a1y*i+b1y*j))*a)/gb3y
	    xpos=(Mgx+(a1x*i+b1x*j))*a

	    if(((xpos.ge.xmin).AND.(xpos.le.xmax)).OR.notruncate) then	    
c	    write(*,*) 'Mg1 ', (Mgx+(a1x*i+b1x*j))*a,
c     c	    (Mgy+(a1y*i+b1y*j))*a, 0.0	    

     	    atoms=atoms+1
	    Id(atoms)='1 '
     	    Xc(atoms)=(Mgx+(a1x*i+b1x*j))*a
	    Yc(atoms)=(Mgy+(a1y*i+b1y*j))*a -(Deltay*a)
	    Zc(atoms)=0.0
	    C(atoms)=1

     	    atoms=atoms+1
	    Id(atoms)='2 '
     	    Xc(atoms)=(Mgx+(a1x*i+b1x*j))*a
	    Yc(atoms)=(Mgy+(a1y*i+b1y*j))*a -(Deltay*a)
	    Zc(atoms)=a/2.0d0
	    C(atoms)=1
     	    endif     
	  enddo
	enddo
	

c	crystal 2
	Ox=0.0
	Oy=0.0
	
	Mgx=0.5*a2x
	Mgy=0.5*a2y


	do i=namin,namax
	  do j=nbmin,nbmax

c	ensure atoms within defined grains	  

c	crystal 2 boundaries     
c     	ymin=gb1y*x/gb1x
c	xmax=(((a2x*n2))*a)-((gb2x*(((a2y*n2))*a))/gb2y)+gb2x*y/gb2y

	    ymin=gb1y*((Ox+(a2x*i+b2x*j))*a)/gb1x
  	    xmax=(((a2x*n2))*a)-((gb2x*(((a2y*n2))*a))/gb2y)
     c	    +gb2x*((Oy+(a2y*i+b2y*j))*a)/gb2y
	    xpos=(Ox+(a2x*i+b2x*j))*a
	    ypos=(Oy+(a2y*i+b2y*j))*a

	    if(((xpos.le.xmax).AND.(ypos.ge.ymin)).OR.notruncate) then
c	    write(*,*) 'O2  ', (Ox+(a2x*i+b2x*j))*a,
c     c	    (Oy+(a2y*i+b2y*j))*a, 0.0
     

	    if(togglecryst2) then
       	    atoms=atoms+1
	    Id(atoms)='1 '
     	    Xc(atoms)=(Ox+(a2x*i+b2x*j))*a-(Deltax*0.5d0*a)
	    Yc(atoms)=(Oy+(a2y*i+b2y*j))*a
	    Zc(atoms)=0.0
	    C(atoms)=2
	    
       	    atoms=atoms+1
	    Id(atoms)='2 '
     	    Xc(atoms)=(Ox+(a2x*i+b2x*j))*a-(Deltax*0.5d0*a)
	    Yc(atoms)=(Oy+(a2y*i+b2y*j))*a
	    Zc(atoms)=a/2.0d0
	    C(atoms)=2	 
	    else
       	    atoms=atoms+1
	    Id(atoms)='2 '
     	    Xc(atoms)=(Ox+(a2x*i+b2x*j))*a-(Deltax*0.5d0*a)
	    Yc(atoms)=(Oy+(a2y*i+b2y*j))*a
	    Zc(atoms)=0.0
	    C(atoms)=2
	    
       	    atoms=atoms+1
	    Id(atoms)='1 '
     	    Xc(atoms)=(Ox+(a2x*i+b2x*j))*a-(Deltax*0.5d0*a)
	    Yc(atoms)=(Oy+(a2y*i+b2y*j))*a
	    Zc(atoms)=a/2.0d0
	    C(atoms)=2	 	    
	       
	    endif
            endif
     

	    ymin=gb1y*((Mgx+(a2x*i+b2x*j))*a)/gb1x
  	    xmax=(((a2x*n2))*a)-((gb2x*(((a2y*n2))*a))/gb2y)
     c	    +gb2x*((Mgy+(a2y*i+b2y*j))*a)/gb2y
	    xpos=(Mgx+(a2x*i+b2x*j))*a
	    ypos=(Mgy+(a2y*i+b2y*j))*a

	    if(((xpos.le.xmax).AND.(ypos.ge.ymin)).OR.notruncate) then
c	    write(*,*) 'Mg2 ', (Mgx+(a2x*i+b2x*j))*a,
c     c	    (Mgy+(a2y*i+b2y*j))*a, 0.0	    

	    if(togglecryst2) then     
       	    atoms=atoms+1
	    Id(atoms)='2 '
     	    Xc(atoms)=(Mgx+(a2x*i+b2x*j))*a-(Deltax*0.5d0*a)
	    Yc(atoms)=(Mgy+(a2y*i+b2y*j))*a
	    Zc(atoms)=0.0
	    C(atoms)=2     

       	    atoms=atoms+1
	    Id(atoms)='1 '
     	    Xc(atoms)=(Mgx+(a2x*i+b2x*j))*a-(Deltax*0.5d0*a)
	    Yc(atoms)=(Mgy+(a2y*i+b2y*j))*a
	    Zc(atoms)=a/2.0d0
	    C(atoms)=2 
	    else
       	    atoms=atoms+1
	    Id(atoms)='1 '
     	    Xc(atoms)=(Mgx+(a2x*i+b2x*j))*a-(Deltax*0.5d0*a)
	    Yc(atoms)=(Mgy+(a2y*i+b2y*j))*a
	    Zc(atoms)=0.0
	    C(atoms)=2     

       	    atoms=atoms+1
	    Id(atoms)='2 '
     	    Xc(atoms)=(Mgx+(a2x*i+b2x*j))*a-(Deltax*0.5d0*a)
	    Yc(atoms)=(Mgy+(a2y*i+b2y*j))*a
	    Zc(atoms)=a/2.0d0
	    C(atoms)=2 	    
	    endif
            endif     
	  enddo
	enddo


c	crystal 3
	Ox=n1
	Oy=0.0
	
	Mgx=n1+0.5*a3x
	Mgy=0.5*a3y

	do i=namin,namax
	  do j=nbmin,nbmax

c	ensure atoms within defined grains	  
	  
c	crystal 3 boundaries     
c     	ymin=(((a1y*n1))*a)-(gb3y*(((a1x*n1))*a)/gb3x)+(gb3y*x/gb3x)
c	xmin=(((a2x*n2))*a)-((gb2x*(((a2y*n2))*a))/gb2y)+gb2x*y/gb2y
	  
	    ymin=(((a1y*n1))*a)-(gb3y*(((a1x*n1))*a)/gb3x)+
     c	    (gb3y*((Ox+(a3x*i+b3x*j))*a)/gb3x)
  	    xmin=(((a2x*n2))*a)-((gb2x*(((a2y*n2))*a))/gb2y)+
     c	    gb2x*((Oy+(a3y*i+b3y*j))*a)/gb2y
	    xpos=(Ox+(a3x*i+b3x*j))*a
	    ypos=(Oy+(a3y*i+b3y*j))*a
	  
	    if(((xpos.ge.xmin).AND.(ypos.ge.ymin)).OR.notruncate) then	  
c	    write(*,*) 'O3  ', (Ox+(a3x*i+b3x*j))*a,
c     c	    (Oy+(a3y*i+b3y*j))*a, 0.0

       	    atoms=atoms+1
	    Id(atoms)='2 '
     	    Xc(atoms)=(Ox+(a3x*i+b3x*j))*a+(Deltax*0.5d0*a)
	    Yc(atoms)=(Oy+(a3y*i+b3y*j))*a
	    Zc(atoms)=0.0
	    C(atoms)=3     
	    
       	    atoms=atoms+1
	    Id(atoms)='1 '
     	    Xc(atoms)=(Ox+(a3x*i+b3x*j))*a+(Deltax*0.5d0*a)
	    Yc(atoms)=(Oy+(a3y*i+b3y*j))*a
	    Zc(atoms)=a/2.0d0
	    C(atoms)=3 	    
            endif
	    
	    ymin=(((a1y*n1))*a)-(gb3y*(((a1x*n1))*a)/gb3x)+
     c	    (gb3y*((Mgx+(a3x*i+b3x*j))*a)/gb3x)
  	    xmin=(((a2x*n2))*a)-((gb2x*(((a2y*n2))*a))/gb2y)+
     c	    gb2x*((Mgy+(a3y*i+b3y*j))*a)/gb2y
	    xpos=(Mgx+(a3x*i+b3x*j))*a
	    ypos=(Mgy+(a3y*i+b3y*j))*a
	  
	    if(((xpos.ge.xmin).AND.(ypos.ge.ymin)).OR.notruncate) then	  
c	    write(*,*) 'Mg3 ', (Mgx+(a3x*i+b3x*j))*a,
c     c	    (Mgy+(a3y*i+b3y*j))*a, 0.0	    

       	    atoms=atoms+1
	    Id(atoms)='1 '
     	    Xc(atoms)=(Mgx+(a3x*i+b3x*j))*a+(Deltax*0.5d0*a)
	    Yc(atoms)=(Mgy+(a3y*i+b3y*j))*a
	    Zc(atoms)=0.0
	    C(atoms)=3     
	    
       	    atoms=atoms+1
	    Id(atoms)='2 '
     	    Xc(atoms)=(Mgx+(a3x*i+b3x*j))*a+(Deltax*0.5d0*a)
	    Yc(atoms)=(Mgy+(a3y*i+b3y*j))*a
	    Zc(atoms)=a/2.0d0
	    C(atoms)=3     	    
            endif
	  enddo
	enddo


c	WRITE OUT GB PLANES
c	write(*,*) 'Ga ', gb1x*20.0*a,
c     c	    gb1y*20.0*a, 0.0
     
c	crystal 1 boundaries     
c     	xmin=gb1x*y/gb1y
c	xmax=((a1x*n1))*a)-((gb3x*(((a1y*n1))*a))/gb3y)+gb3x*y/gb3y
	
c	Ox=0.0
c	Oy=0.0
c	write(*,*) 'Ga ',((Ox+(a2x*n2))*a)+gb2x*20.0*a,
c     c	    ((Oy+(a2y*n2))*a)+gb2y*20.0*a, 0.0
     
c	crystal 2 boundaries     
c     	ymin=gb1y*x/gb1x
c	xmax=(((a2x*n2))*a)-((gb2x*(((a2y*n2))*a))/gb2y)+gb2x*y/gb2y
     
c	Ox=0.0
c	Oy=0.0
c	write(*,*) 'Ga ',((Ox+(a1x*n1))*a)+gb3x*20.0*a,
c     c	    ((Oy+(a1y*n1))*a)+gb3y*20.0*a, 0.0

c	crystal 3 boundaries     
c     	ymin=(((a1y*n1))*a)-(gb3y*(((a1x*n1))*a)/gb3x)+(gb3y*x/gb3x)
c	xmin=(((a2x*n2))*a)-((gb2x*(((a2y*n2))*a))/gb2y)+gb2x*y/gb2y



c	REMOVE ATOMS TOO CLOSE
	if(closecheck) then
	  do i=1,atoms
	    do j=1,atoms
	    if (i.ne.j) then
	      xx=(Xc(i)-Xc(j))*(Xc(i)-Xc(j))
	      yy=(Yc(i)-Yc(j))*(Yc(i)-Yc(j))	      
	      zz=(Zc(i)-Zc(j))*(Zc(i)-Zc(j))	    
	      dist=sqrt(xx+yy+zz)
	      if(dist.le.tol) then
	      xx=(Xc(i)+Xc(j))/2.0d0
	      yy=(Yc(i)+Yc(j))/2.0d0	      
	      zz=(Zc(i)+Zc(j))/2.0d0	      
	      Xc(i)=xx
	      Yc(i)=yy
	      Zc(i)=zz

	      Xc(j)=1.0e5
	      Yc(j)=1.0e5
	      Zc(j)=1.0e5
	      C(j)=0
	      endif
	    endif
	    enddo
	  enddo
	endif


c	WRITE OUT ATOMS

c	count atoms in crystal
	atomscrys=0
	do I=1,atoms
	  if(C(i).ne.0) then
	    atomscrys=atomscrys+1
	  endif
	enddo
	
	write(*,"(I4)") atomscrys
c	write(*,*) 'Atoms. Timestep: 0'
	write(*,"(I2)") 0
	do I=1,atoms
	  if(C(i).ne.0) then
	    write(*,*) Id(i),Zc(i), Xc(i),Yc(i)
	  endif
	enddo

      end program


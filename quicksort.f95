!quicksort fortran95 
!@author Marco Aurélio
program main
   use iso_fortran_env
   implicit none
   INTEGER(int64) :: seed
   INTEGER :: l, hash, test_n, last_elem_unsorted
   INTEGER, DIMENSION(:), ALLOCATABLE :: ARR
   INTEGER(int64), DIMENSION(11) ::  test_seeds
   INTEGER, DIMENSION(11) :: test_sizes
   INTEGER(int64) :: T1, T2, rate
   
   test_sizes = INT((/1e6, 2e6, 5e6, 1e7, 2e7, 5e7, 1e8, 2e8, 5e8, 1e9, 2e9/))
   test_seeds = (/0, 314, 7676, 202, 457, 1000, 9070140, 2394587, 5827934, 934875, 42/)
   
   CALL setseed(12566161_int64)!Numero USP
   hash=next(31)
   hash=next(31)
   hash=next(31)

                                      !HASH, CPU
   WRITE(*,'(I0,8(XA),X)', advance='no')hash,'https://www.cpubenchmark.net/cpu.php?cpu=Intel+Core+i5-4300M+%40+2.60GHz',&
   !PASSMARK, MEMORIA_RAM, FREQ_RAM, QTD_MEMORIA, QTD_PENTES_MEMORIA, SO, ALGORITMO
   '3011','DDR3','1600','8','2','Microsoft Windows NT 10.0.19043.0','QUICKSORT'


   CALL system_clock(count_rate=rate)

   do test_n = 1, 11
      CALL setseed(test_seeds(test_n))

      ALLOCATE(ARR(test_sizes(test_n)))
      do l = 1, test_sizes(test_n)
         ARR(l) = next(31)
      end do

      last_elem_unsorted = ARR(SIZE(ARR))
   
      CALL system_clock(T1)
      CALL quicksort(ARR, 1, SIZE(ARR))
      CALL system_clock(T2)
   
      WRITE(*,'(I0,XF0.4,X)', advance='no')last_elem_unsorted,(REAL(T2-T1)/REAL(rate))*1e6
   
      DEALLOCATE(ARR)
   end do
contains
   !RNG-java8
   subroutine setseed(newSeed)
      implicit none
      INTEGER(KIND=8), INTENT(IN) :: newSeed

      seed = AND((TRANSFER(XOR(newSeed, Z'5DEECE66D'), 1_int64)), (ISHFT(1_int64, 48) - 1))

   end subroutine setseed

   function next(bits) result(retval)
      implicit none
      INTEGER, INTENT(IN) :: bits
      INTEGER :: retval

      seed = AND(seed * INT(Z'5DEECE66D', int64) + INT(Z'B',int64), (ISHFT(1_int64, 48) - 1))
      retval = INT(ISHFT(seed, -(48 - bits)))

   end function next
   
   function partition(A, left, right) result(returnval) 
      implicit none
      INTEGER, DIMENSION(:), INTENT(INOUT) :: A
      INTEGER, INTENT(IN) :: left, right
      INTEGER :: pivot, i, j, temp, returnval
      
      !pivot = A(INT((left+right)/2))
      pivot = A(right)
      i = left-1
      
      do j = left, (right-1)
         if (A(j) <= pivot) then
            i=i+1
            temp = A(i); A(i) = A(j); A(j) = temp
         end if
      end do
      temp = A(i+1); A(i+1) = A(right); A(right) = temp
      returnval = i+1
   end function partition
   
   recursive subroutine quicksort(A, left, right)
   implicit none
   INTEGER, DIMENSION(:), INTENT(INOUT) :: A
   INTEGER,INTENT(IN) :: left, right
   INTEGER :: marker
   
   if (left<right) then
      marker = partition(A, left, right)
      CALL quicksort(A, left, marker-1)
      CALL quicksort(A, marker+1, right)
   end if
   
   end subroutine quicksort
end program main

!Porte do rng-java8 para fortran95 
!@author Marco Aurélio
program main
   use iso_fortran_env
   implicit none
   INTEGER(int64) :: seed
   INTEGER :: l, arr_s
   INTEGER, DIMENSION(:), ALLOCATABLE :: ARR
   INTEGER(int64) :: T1, T2, rate
   
   arr_s = 500E3 ! array size

   CALL setseed(X'A0A0A0A0A0A0A0A0')

   ALLOCATE(ARR(arr_s))
   do l = 1, arr_s
      ARR(l) = next(31)
   end do

   CALL system_clock(count_rate=rate)

   !WRITE(*,'(A/,*(I11))')'unsorted:', ARR(:)

   CALL system_clock(T1)
   CALL quicksort(ARR, 1, SIZE(ARR))
   CALL system_clock(T2)

   !WRITE(*,'(A/,*(I11))')'sorted:', ARR(:)
   WRITE(*,'(A, EN16.8)') 'time elapsed:', REAL(T2-T1)/REAL(rate)

   DEALLOCATE(ARR)

contains
   !RNG-java8
   subroutine setseed(newSeed)
      implicit none
      INTEGER(KIND=16), INTENT(IN) :: newSeed

      seed = AND((TRANSFER(XOR(newSeed, X'5DEECE66D'), 1_int64)), (ISHFT(1_int64, 48) - 1))

   end subroutine setseed

   function next(bits) result(retval)
      implicit none
      INTEGER, INTENT(IN) :: bits
      INTEGER :: retval

      seed = AND(TRANSFER(seed * X'5DEECE66D' + X'B', 1_int64), (ISHFT(1_int64, 48) - 1))
      retval = INT(ISHFT(seed, -(48 - bits)))

   end function next
   
   function partition(A, left, right) result(returnval) 
      implicit none
      INTEGER, DIMENSION(:), INTENT(INOUT) :: A
      INTEGER, INTENT(IN) :: left, right
      INTEGER :: pivot, i, j, temp, returnval
      
      pivot = A(INT((left+right)/2))
      !pivot = A(right)
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

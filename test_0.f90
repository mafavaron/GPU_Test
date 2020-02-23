module simpleOps_m
contains

	attributes(global) subroutine increment(a, b)
	
		implicit none
		
		integer, dimension(:), intent(inout)	:: a
		integer, value							:: b
		
		integer									:: i
		
		i = threadIdx % x
		
		a(i) = a(i) + b
		
	end subroutine increment

end module simpleOps_m


program incrementTestGPU

	use cudafor
	use simpleOps_m
	
	implicit none
	
	integer, parameter	:: n = 256
	integer				:: a(n), b
	integer, device		:: a_d(n)
	
	a = 1
	b = 3
	
	a_d = a
	call increment<<<1,n>>>(a_d, b)
	a = a_d
	
	if(any(a /= 4)) then
		print *, 'Fail'
	else
		print *, 'Pass'
	end if

end program incrementTestGPU

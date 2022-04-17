#include <stdio.h>
#include<stdint.h>
#include<stdlib.h>
#include "gcd.h"
uint32_t m_w = 50000;
uint32_t m_z = 60000;


uint32_t random_in_range(uint32_t low, uint32_t high)
{
  uint32_t range = high-low+1;
  uint32_t rand_num = get_random();

  return (rand_num % range) + low;
}


// Generate random 32-bit unsigned number
// based on multiply-with-carry method shown
// at http://en.wikipedia.org/wiki/Random_number_generation

uint32_t get_random()
{
  uint32_t result;
  m_z = 36969 * (m_z & 65535) + (m_z >> 16);
  m_w = 18000 * (m_w & 65535) + (m_w >> 16);
  result = (m_z << 16) + m_w;  /* 32-bit result */
  return result;
}

    
int main()
    {
      uint32_t n1, n2;
    
      int i=0;

      for(i=0;i<10;i++) {   
        n1=random_in_range(1,10000);
        n2=random_in_range(1,10000);
       
        printf("\n G.C.D of %u and %u is %u.", n1, n2, gcd(n1,n2));
      } 
      return 0;
    }
    
uint32_t gcd(uint32_t n1, uint32_t n2)
    {
        if (n2 != 0)
           return gcd(n2, n1%n2);
        else 
           return n1;
    }

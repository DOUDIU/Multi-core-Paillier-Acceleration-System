import gmpy2

n=0xc1df05419c6057e26ebad2d3abd7123cdd612c4cf0c09d1881f83b3ea46ad2f1239e21d0a3a778cfbfa9f4f46a0f355c3c57d0305706482133aa5b0aa7d961798442d0c0a2d7fd48359690c361c66fa0dc7131e9dcf83e11cab3812b22861546a5be250c5ab7d671d5e6129b0ef708e105d2d0ed5bde948bf5c4339c0d7e45b9c3ac4ef3c50af15fbd37492f126c5a518af725228255ab1b6ecab2f668149e3ff74e3cd371e7fadf3edb24476ca0632fa53d0af0840ed39b736a5f08339a21e35a53aa612f73dabd6864bf2dc85b296b4e2a2bddcdabdae21b8c938d1c95d3278213cc126746497a511d8d29aea5ac13d2c5de79b62fb1a1a8e12114c110a8bf
q=0xe40930748c4cc8fe2bf3b56c194415fd1e08df9e174bf74ecc089960fa48143c64fdfeeae3dd9a9fc7932dd676d4110f7be0755d4a8a31f02252f084be03511ff5fd781f17e17dc6c530053829b2b4eab676ed7b9494b822063b4cb912eb3662c873081b60a5376f4ba17c10b3aec703802b4b437c8c6201a3ef1f6ad26ca7a9
p=0xd9a5494352130cb1e50bf14a4d7526d3f341ecaec20771cf0246364aaf97a3c02648abf5f5e927e97dcc8485aabc7139181c9edeb65370174f83e09a818bd0bb2e98a30e1ff8b94655fcd0867d7ab4cd714822085245cf4cb0de82966240856658d3903fc8cd6b5901716c3573ec02c62235ada01abc98b9f9b54a4c9004ee27

def data_seperate_printf_new(data,nbit,n,order,file_path):#0 reverse,1 normal
    RESULT_LOG = open(file_path,'w').close()
    RESULT_LOG = open(file_path,'a',encoding="utf-8")
    if order==0:
        for i in range(n):
            print('{:x}'.format(data>>(i*nbit)&(2**nbit-1)),end='\n',file=RESULT_LOG)
    else:
        for i in range(n-1,-1,-1):
            print('{:x}'.format(data>>(i*nbit)&(2**nbit-1)),end='\n',file=RESULT_LOG)

def ram_pre_cal_me_n2():
    m = n * n
    file_path = '1.RTL/data/ram_me_m.txt'
    data_seperate_printf_new(m,128,4096//128,0,file_path)

    file_path = '1.RTL/data/ram_me_rou.txt'
    rou = gmpy2.powmod(2,4096*2,m)
    data_seperate_printf_new(rou,128,4096//128,0,file_path)

    file_path = '1.RTL/data/ram_me_result.txt'
    result = gmpy2.powmod(2,4096,m)
    data_seperate_printf_new(result,128,4096//128,0,file_path)

    file_path = '1.RTL/data/ram_me_result_backup.txt'
    data_seperate_printf_new(result,128,4096//128,0,file_path)

def ram_pre_cal_mm_n2():
    m = n * n

    file_path = '1.RTL/data/ram_mm_m_n2.txt'
    data_seperate_printf_new(m,128,4096//128,0,file_path)

    file_path = '1.RTL/data/ram_mm_rou_n2.txt'
    rou = gmpy2.powmod(2,4096*2,m)
    data_seperate_printf_new(rou,128,4096//128,0,file_path)

def ram_pre_cal_mm_n():
    m = n

    file_path = '1.RTL/data/ram_mm_m_n.txt'
    data_seperate_printf_new(m,128,4096//128,0,file_path)

    file_path = '1.RTL/data/ram_mm_rou_n.txt'
    rou = gmpy2.powmod(2,4096*2,m)
    data_seperate_printf_new(rou,128,4096//128,0,file_path)

def ram_pre_cal_mm_inv():
    m = ((p - 1) * (q - 1)) + n

    file_path = '1.RTL/data/ram_mm_m_inv.txt'
    data_seperate_printf_new(m,128,4096//128,0,file_path)

    file_path = '1.RTL/data/ram_mm_rou_inv.txt'
    rou = gmpy2.powmod(2,4096*2,m)
    data_seperate_printf_new(rou,128,4096//128,0,file_path)

def reg_m1_print():
    k=4096//32
    beta=2**k

    m = n * n
    p1=((-1*(gmpy2.invert(m,beta)))%beta)%(2**128)#The lower 128-bit data is reserved.
    print('m1_n2:\n0x{:x}\n'.format(p1))

    m = n
    p1=((-1*(gmpy2.invert(m,beta)))%beta)%(2**128)#The lower 128-bit data is reserved.
    print('m1_n:\n0x{:x}\n'.format(p1))

    m = ((p - 1) * (q - 1)) + n
    p1=((-1*(gmpy2.invert(m,beta)))%beta)%(2**128)#The lower 128-bit data is reserved.
    print('m1_inv:\n0x{:x}\n'.format(p1))

def ram_pre_dec():
    dec_inv_m = ((p-1)*(q-1)) + n
    inv_val = gmpy2.invert(n, dec_inv_m)
    file_path = '1.RTL/data/ram_dec_inv_val.txt'
    data_seperate_printf_new(inv_val,128,4096//128,0,file_path)

if __name__=='__main__':
    ram_pre_cal_me_n2()
    ram_pre_cal_mm_n2()
    ram_pre_cal_mm_n()
    ram_pre_cal_mm_inv()

    reg_m1_print()

    ram_pre_dec()
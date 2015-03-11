#ifndef _SANSEC_SMT_ERRNO_H
#define _SANSEC_SMT_ERRNO_H

enum {
    SUCCESS = 0x0000,                   //成功
    ERR_MEMORY_ALLOC,                   //内存申请失败
    ERR_BUFFER_TOO_SHORT,               //缓冲区太小
    ERR_INVALID_PARAMETER,              //参数非法
    ERR_PFX_FILE_NOT_EXSIT,             //pfx文件不存在
    ERR_PFX_FILE_OPEN,                  //pfx文件打开失败
    ERR_PFX_FILE_WIRTE,                 //pfx文件写失败
    ERR_SERVER_CERT_FILE_NOT_EXSIT,     //服务器证书不存在
    ERR_SERVER_CERT_FILE_OPEN,          //服务器证书打开失败
    ERR_SERVER_CERT_FILE_READ,          //服务器证书读失败
    ERR_CERT_CACHE_CREATE,  //10        //证书缓存文件创建失败
    ERR_INT_ECC_SIGN_FAILED,            //内部ecc签名失败
    ERR_ALGO_NOT_SUPPORT,               //算法不支持
    ERR_COMM,                           //通信协议命令错误
    ERR_PROTEL_VER,                     //通信协议版本错误
    ERR_SIGN_LEN,                       //签名长度错误
    ERR_PROTEL_LEN,                     //通信协议包长错误
    ERR_GET_PUB_KEY,                    //获取公钥失败
    ERR_SERVER_VERIFY_FAILED,           //服务器验证失败
    ERR_SERVER_ERROR,                   //服务器错误
    ERR_CIPHER_LEN,     //20            //cipher长度错误
    ERR_INT_ECC_DECRYPT,                //内部ecc解密失败
    ERR_SERVER_RESP_FAILED,             //服务器返回错误
    ERR_SERVER_ALGO_NOT_SUPPORT,        //服务器端算法不支持
    ERR_CALL_KEY_IS_NULL,               //通话密钥为空
    ERR_ENCRYPT_SM4_ECB,                //SM4加密失败
    ERR_DECRYPT_SM4_ECB,                //SM4解密失败
    ERR_GET_CERT,                       //获取证书出错
    ERR_EXT_ECC_VERIFY,                 //ecc验证失败
    ERR_PFX_GET_CERT,                   //pfx文件获取证书失败
    ERR_CERT_GET_SUBJECT_INFO, //30     //获取证书信息失败
    ERR_CERT_GET_PUB_KEY,               //从证书获取公钥失败
    ERR_CERT_GET_SERIAL_NUM,            //从证书获取序列号失败
    ERR_SOCKET_CONNECT,                 //socket连接失败
    ERR_SOCKET_SEND,                    //socket发送失败
    ERR_SOCKET_RECERVE,                 //socket接收失败
    ERR_GEN_RANDOM_KEY,                 //随机密钥生生成失败
    ERR_EXT_ECC_ENCRYPT,                //ecc加密失败
    ERR_SOFT_INIT,                      //编解码库初始化失败
};

#endif

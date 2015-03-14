#ifndef _SANSEC_SMT_H
#define _SANSEC_SMT_H

#include <stdbool.h>

typedef struct smt_t smt_t;

/*********************************************************************************
 *Function:     smt_init
 *Description:  sdk初始化
 *Input:
        storagePath:    app存储路径
        pfxFile:        pfx文件绝对路径
        srvCertFile:    服务器证书文件绝对路径
        phoneNum:       手机号
        ip:             云密管平台ip
        port:           云密管平台端口
 *Output:
        error:          错误码
 *Return:   smt_t指针，供后续函数调用使用
 **********************************************************************************/
smt_t *smt_init(char *storagePath, char *pfxFile, char *srvCertFile, char *phoneNum, char *ip, int port, int *error);

/*********************************************************************************
 *Function:     smt_getKey
 *Description:  从平台获取对称密钥，供以后通话数据加密
 *Input:
        smt:            sdk初始化时获取的指针
        requestFlag:    请求标识: 1:主叫 2:被叫
        callPhoneNum:   主叫号码
        calledPhoneNum: 被叫号码
 *Return:   返回码，含义参考smt_errno.h
 **********************************************************************************/
int smt_getKey(smt_t *smt, int requestFlag, char *callPhoneNum, char *calledPhoneNum);

/*********************************************************************************
 *Function:     smt_encrypt
 *Description:  使用sm4算法加密数据
 *Input:
        smt:            sdk初始化时获取的指针
        inData:         输入数据
        inLen:          输入数据长度
        outData:        密文接收缓冲区
        outLen:         密文接收缓冲区大小
 *Output:
        outData:        加密后的密文
        outLen:         加密后的密文长度
 *Return:   返回码，含义参考smt_errno.h
 **********************************************************************************/
int smt_encrypt(smt_t *smt, char *inData, int inLen, char *outData, int *outLen);

/*********************************************************************************
 *Function:     smt_decrypt
 *Description:  使用sm4算法解密数据
 *Input:
        smt:            sdk初始化时获取的指针
        inData:         输入数据
        inLen:          输入数据长度
        outData:        解密数据接收缓冲区
        outLen:         解密数据接收缓冲区大小
 *Output:
        outData:        解密后的明文
        outLen:         解密后的明文长度
 *Return:   返回码，含义参考smt_errno.h
 **********************************************************************************/
int smt_decrypt(smt_t *smt, char *inData, int inLen, char *outData, int *outLen);

/*********************************************************************************
 *Function:     smt_genDigitalEnvelope
 *Description:  生成数字信封
 *Input:
        smt:            sdk初始化时获取的指针
        inData:         输入数据
        inLen:          输入数据长度
        calledPhoneNum: 被叫号码
        envelope:       数字信封接收缓冲区
        envelopeLen:    数字信封接收缓冲区大小
 *Output:
        envelope:       数字信封
        envelopeLen:    数字信封长度
 *Return:   返回码，含义参考smt_errno.h
 **********************************************************************************/
int smt_genDigitalEnvelope(smt_t *smt, char *inData, int inLen, char *calledPhoneNum,
                            char *envelope, int *envelopeLen);

/*********************************************************************************
 *Function:     smt_resolveDigitalEnvelope
 *Description:  解数字信封
 *Input:
        smt:            sdk初始化时获取的指针
        envelope:       数字信封接收缓冲区
        envelopeLen:    数字信封接收缓冲区大小
        callerPhoneNum: 主叫号码
        outData:        数字信封内容接收缓冲区
        outLen:         数字信封内容接收缓冲区大小
 *Output:
        outData:        数字信封内容
        outLen:    数字信封内容长度
 *Return:   返回码，含义参考smt_errno.h
 **********************************************************************************/
int smt_resolveDigitalEnvelope(smt_t *smt, char *envelope, int envelopseLen, char *callerPhoneNum,
                            char *outData, int *outLen);

/*********************************************************************************
 *Function:     smt_updateUserCert
 *Description:  更新证书
 *Input:
        smt:            sdk初始化时获取的指针
        phoneNum:       证书关联的电话号码
 *Return:   返回码，含义参考smt_errno.h
 **********************************************************************************/
int smt_updateUserCert(smt_t *smt, char *phoneNum);

/*********************************************************************************
 *Function:     smt_getSubjectInfo
 *Description:  获取证书主体
 *Input:
        smt:            sdk初始化时获取的指针
        data:           证书主体信息接收缓冲区
        len:            证书主体信息接收缓冲区大小
 *Output:
        data:           证书主体信息
        len:            证书主体信息长度
 *Return:   返回码，含义参考smt_errno.h
 **********************************************************************************/
int smt_getSubjectInfo(smt_t *smt, char *data, int *len);

/*********************************************************************************
 *Function:     smt_release
 *Description:  sdk资源释放
 *Input:
        smt:            sdk初始化时获取的指针
 *Return:   返回码，含义参考smt_errno.h
 **********************************************************************************/
int smt_release(smt_t *smt);

#endif

/*******************************************************************************
    Copyright (C), 1988-2006, Huawei Tech. Co., Ltd.

    FileName   : sstxntuintf.x

    Author     : Bajeed

    Version    : 1.0

    Date       : 2005-09-08

    Description: This header file contains the API provided by the transaction
                 component for the transaction users


      Core Library Upper interface
            |           /|\
            |            |------------> TU Lower interface (Register Interface)
            |------------|------------> Core Lib Upper interface
           \|/           |
       +---------------------+
       |    Core Library     |
       +---------------------+

    Function List:
        1. SipTxnHiSfReqInd
        2. SipTxnHiSfMatchedCancelInd
        3. SipTxnHiSfRspInd
        4. SipTxnHiSlReqInd
        5. SipTxnHiSlRspInd
        6. SipTxnHiSfReqTimeout
        7. SipTxnRegTxnTuOptIntf
        8. SipTxnHiSfSendCancel
        9. SipTxnHiSfSendReq
        10.SipTxnHiSfSendRsp
        11.SipTxnHiSlSendReq
        12.SipTxnHiSlSendRsp
        13.SipTxnHiTerminateTxn

    History:
        1. Date         : <YYYY-MM-DD>
           Tag          :
           Author       :
           Modification :
*******************************************************************************/

#ifndef _SS_TXN_TU_INTF_X_
#define _SS_TXN_TU_INTF_X_


#include "ssdatatype.h"
#include "ssmessage.h"
#include "sssipbase.h"


#ifdef __cplusplus
extern "C" {
#endif


typedef struct _SipTxnHiAuxDataS
{
    SS_UINT32 ulDummy; /* This is dummy now, used for future extension */
}SipTxnHiAuxDataS;


/*******************************************************************************
 Function   : SipTxnHiSfReqInd

 Description: This API will be invoked by the TXN component to send a request
              message to TU in stateful manner.

 Input      : ulTxnObjId   - The object of the TXN which corresponds to this
                             request
              pstSipSdu    - Pointer to the SIP Stack data Unit, contains
                             SipMsg, this param can not be NULL
              pstTptNwInfo - Transport Network information, contains source
                             address and Destination address, this param
                             can not be NULL
              pstAuxData   - Aux Data of the stack, for future extension

 Output     : pulTuObjId - The object ID of the TU, now TU need not acknowledge
                           this message with transaction ACK API

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
EN_SIP_RESULT SipTxnHiSfReqInd
(
    IN SS_UINT32         ulTxnObjId,
    IN SipDataUnitS     *pstSipSdu,
    IN SipTptNwInfoS    *pstTptNwInfo,
    IN SipTxnHiAuxDataS *pstAuxData,
    IO SS_UINT32        *pulTuObjId
);


/*******************************************************************************
 Function   : SipTxnHiSfMatchedCancelInd

 Description: This API will be invoked by the TXN component to send a matched
              CANCEL message to TU in stateful manner. If the Transaction can
              find a matching transaction for the CANCEL request, it will
              indicate TU as an matched CANCEL along with matched transaction id

 Input      : ulCanceledTuObjId  - The object of the TU which corresponds to
                                   INVITE request that is to be canceled
              ulCanceledTxnObjId - The object of the TXN which corresponds to
                                   INVITE request that is to be canceled
              pstSipSdu    - Pointer to the SIP Stack data Unit, contains
                             SipMsg, this param can not be NULL
              pstTptNwInfo - Transport Network information, contains source
                             address and Destination address, this param
                             can not be NULL
              pstAuxData   - Aux Data of the stack, for future extension

 Output     : None

 Return     : VOID
*******************************************************************************/
SS_VOID SipTxnHiSfMatchedCancelInd
(
    IN SS_UINT32         ulCanceledTuObjId,
    IN SS_UINT32         ulCanceledTxnObjId,
    IN SipDataUnitS     *pstSipSdu,
    IN SipTptNwInfoS    *pstTptNwInfo,
    IN SipTxnHiAuxDataS *pstAuxData
);


/*******************************************************************************
 Function   : SipTxnHiSfRspInd

 Description: This API will be invoked by the TXN component to send the response
              received from the network or the response internally generated by
              the stack to the TU. TU can check the bFromNetwork flag in SipMsg
              in SipSdu to see if the response is coming from network or it is
              internally generated. when some local error occurs or ICMP error
              occurs while sending the request, stack will internally generate
              the response message and indicate to TU. depending upon the
              status code TU can retry the request.

 Input      : ulTuObjId    - The object id of the TU which corresponds to the
                             response being indicated
              ulTxnObjId   - The object id of the TXN which corresponds to
                             the response message
              pstSipSdu    - Pointer to the SIP Stack data Unit, contains
                             SipMsg, this param can not be NULL
              pstTptNwInfo - Transport Network information, contains source
                             address and Destination address
              pstAuxData   - Aux Data of the stack, for future extension

 Output     : None

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
SS_VOID SipTxnHiSfRspInd
(
    IN SS_UINT32         ulTuObjId,
    IN SS_UINT32         ulTxnObjId,
    IN SipDataUnitS     *pstSipSdu,
    IN SipTptNwInfoS    *pstTptNwInfo,
    IN SipTxnHiAuxDataS *pstAuxData
);

/*******************************************************************************
 Function   : SipTxnHiSlReqInd

 Description: This API will be invoked by the TXN component to intimate
              a request received from the network to TU in stateless manner.
              When a request is received from network and it is not a
              transaction creating request, and does not match any existing
              transaction it will be indicated to TU using stateless interface.
              Ack request for INVITE is indicated using this interface.

 Input      : pstSipSdu    - Pointer to the SIP Stack data Unit, contains
                             SipMsg, this param can not be NULL
              pstTptNwInfo - Transport Network information, contains source
                             address and Destination address, this param
                             can not be NULL
              pstAuxData   - Aux Data of the stack, for future extension

 Output     : None

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
EN_SIP_RESULT SipTxnHiSlReqInd
(
    IN SipDataUnitS     *pstSipSdu,
    IN SipTptNwInfoS    *pstTptNwInfo,
    IN SipTxnHiAuxDataS *pstAuxData
);

/*******************************************************************************
 Function   : SipTxnHiSlRspInd

 Description: This API will be invoked by the TXN component to indicate a
              response to TU, which is received from the network, and does not
              match any existing transactions.
              This interface is generally used to indicate retransmitted 2xx
              for INVITE and other stray responses. If the TU is acting as UA,
              and If the response is 2xx for INVITE, then TU should retransmit
              Ack, and if the response message is stray response, it may decide
              to discard this response message. If the TU is acting as proxy it
              may decide to forward this response message.

 Input      : pstSipSdu    - Pointer to the SIP Stack data Unit, contains
                             SipMsg, this param can not be NULL
              pstTptNwInfo - Transport Network information, contains source
                             address and Destination address, this param
                             can not be NULL
              pstAuxData   - Aux Data of the stack, for future extension

 Output     : None

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
EN_SIP_RESULT SipTxnHiSlRspInd
(
    IN SipDataUnitS     *pstSipSdu,
    IN SipTptNwInfoS    *pstTptNwInfo,
    IN SipTxnHiAuxDataS *pstAuxData
);



/*******************************************************************************
 Function   : SipTxnHiSfReqTimeout

 Description: This API will be invoked by the Transaction component to indicate
              TU when wait for TU Response timer on TU(TXN_TIMER_RESP_FROM_TU)
              fires in Transaction, i.e. when TU does not respond to the request
              indicated by the transaction within a stipulated time.

 Input      : ulTuObjId    - The object Id of the TU component which TU has used
                             while sending the request. Transaction will give
                             the same id back to TU.
              ulTxnObjId   - The object id of the transaction which was used to
                             send request indication to TU
              pstSipSdu    - Pointer to the SIP Stack data Unit, contains
                             request message which was timed out
              pstAuxData   - Aux Data of the stack, for future extension

 Output     : None

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
SS_VOID SipTxnHiSfReqTimeout
(
    IN SS_UINT32         ulTuObjId,
    IN SS_UINT32         ulTxnObjId,
    IN SipDataUnitS     *pstSipSdu,
    IN SipTxnHiAuxDataS *pstAuxData
);



/*******************************************************************************
 Function   : pFnSipTxnHiSfUnmatchedCancelInd

 Description: This API will be invoked by the TXN component to send unmatched
              CANCEL message to TU. If the Transaction did not find a matching
              transaction for the CANCEL request, it will indicate TU as an
              unmatched CANCEL. This is not mandatory to register this callback
              interface.

 Input      : ulTxnObjId   - The object of the TXN which corresponds to
                             the unmatched CANCEL message
              pstSipSdu    - Pointer to the SIP Stack data Unit, contains
                             SipMsg, this param can not be NULL
              pstTptNwInfo - Transport Network information, contains source
                             address and Destination address, this param
                             can not be NULL
              pstAuxData   - Aux Data of the stack, for future extension

 Output     : pulTuObjId - The object ID of the TU, this id is used to send
                           response for this request

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
typedef EN_SIP_RESULT (*pFnSipTxnHiSfUnmatchedCancelInd)
(
    IN SS_UINT32         ulTxnObjId,
    IN SipDataUnitS     *pstSipSdu,
    IN SipTptNwInfoS    *pstTptNwInfo,
    IN SipTxnHiAuxDataS *pstAuxData,
    IO SS_UINT32        *pulTuObjId
);



/*********************************************************************(*********
 Function   : pFnSipTxnHiSlMsgSendResultInd

 Description: This API will be invoked by the Transaction component to relay the
              Result indication (of a message sent to network) received from TPT
              to TU. When TU send 2xx using stateful interface Transaction will
              indicate the success result using stateless interface. For Ack TU
              will send req using stateless interface and Txn will indicate
              result using stateless interface.  It is not mandatory to register
              this callback interface, If TU does not want to handle this result
              indication, it need not register this callback interface.

 Input      : ulTuObjId        - The object Id of the TU which corresponds to
                                 request or response sent before by TU
              ulTuObjTimeStamp - If the result message is for stateless message
                                 sent before, then ulTuObjTimeStamp used to send
                                 the message is returned to TU, and if the
                                 result message is for stateful 2xx of INVITE,
                                 then ulTxnObjId which was used to send 2xx
                                 will be indicated as timestamp to TU
              enResultType     - Result code, success or failure code
              pstTptNwInfo - New Transport Network information, contains source
                             address and Destination address
                             stateful 2xx - result is success, must have New
                                            Tpt Info
                             stateless ACK - result is success/failure, if
                                             success, must have New Tpt Info
              pstAuxData   - Aux Data of the stack, for future extension

 Output     : None

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
typedef EN_SIP_RESULT (*pFnSipTxnHiSlMsgSendResultInd)
(
    IN SS_UINT32           ulTuObjId,
    IN SS_UINT32           ulTuObjTimeStamp,
    IN EN_SIP_SEND_RESULT  enResultType,
    IN SipTptNwInfoS      *pstTptNwInfo,
    IN SipTxnHiAuxDataS   *pstAuxData
);


typedef struct _SipTxnTuOptRegFnS
{
    /* Stateful UnMatched CANCEL indication */
    pFnSipTxnHiSfUnmatchedCancelInd pfnSfUnmatchedCancelInd;

    /* Stateless Message failure indication of a message sent to network */
    pFnSipTxnHiSlMsgSendResultInd   pfnSlMsgSendResultInd;
}SipTxnTuOptRegFnS;


/*******************************************************************************
 Function   : SipTxnRegTxnTuOptIntf

 Description: This function will be invoked by TU to register the optional TU
              callback interface functions with transaction component. When
              transaction receives a message from network it will indicate the
              message to TU, in order for TU to receive any message from
              Transaction, it should register the callback interface with
              Transaction.

 Input      : pstTuOptRegFns - Pointer to structure of the TU callback interface
                               function pointers

 Output     : None

 Return     : SIP_RET_SUCCESS or Failure Code
*******************************************************************************/
EN_SIP_RESULT SipTxnRegTxnTuOptIntf
(
    IN SipTxnTuOptRegFnS *pstTuOptRegFns
);



/*******************************************************************************
 Function   : SipTxnHiSfSendReq

 Description: This API will be invoked by the TU component to send a request
              message (except CANCEL and ACK for Invite) to network in stateful
              manner. CANCEL has special treatment in Transaction, and hence has
              a separate interface to send, and Ack for INVITE is always sent
              using stateless interface.

 Input      : ulTuObjId    - The object of the TU which corresponds to this
                             request
              pstSipSdu    - Pointer to the SIP Stack data Unit, contains
                             request message, this request can be any thing
                             except CANCEL and Ack for Invite, and this param
                             can not be NULL
              pstTptNwInfo - Transport Network information, contains source
                             address and Destination address, this param can not
                             be NULL.
              pstAuxData - Aux Data of the stack, for future extension

 Output     : pulTxnObjId - The Id of the transaction object in success case
              pbProtocolSwitched - TRUE If protocol is switched from UDP to TCP.
                                   FALSE, if protocol is not switched, If this
                                   param is NULL, protocol will not be switched

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
EN_SIP_RESULT SipTxnHiSfSendReq
(
    IN SS_UINT32         ulTuObjId,
    IN SipDataUnitS     *pstSipSdu,
    IN SipTptNwInfoS    *pstTptNwInfo,
    IN SipTxnHiAuxDataS *pstAuxData,
    IO SS_UINT32        *pulTxnObjId,
    IO SS_BOOL          *pbProtocolSwitched
);


/*******************************************************************************
 Function   : SipTxnHiSfSendCancel

 Description: This API will be invoked by the TU component to send a CANCEL
              request message to network in stateful manner. CANCEL request
              has a special treatment in Transaction, it should carry the
              Corresponding INVITE Txn and Tu id along with the CANCEL request,
              so MiniSip provide a separate interface for it. TU can only cancel
              a request which it has previously sent out.

 Input      : ulCanceledTxnObjId - The object id of the INVITE transaction
                                   which is to be cancelled. This Id can be
                                   NULL, in which case the transaction will be
                                   looked up using the branch-id in CANCEL,
                                   so CANCEL message must have same branch-id
                                   as INVITE if this param is NULL.
              ulCanceledTuObjId  - The TU object id of the INVITE transaction
                                   to be cancelled.
              ulTuObjId  - The object of the TU which corresponds to this
                           CANCEL request
              pstSipSdu  - Pointer to the SIP Stack data Unit, containing CANCEL
                           request message
              pstAuxData - Aux Data of the stack, for future extension

 Output     : pulTxnObjId -The Id of the CANCEL transaction object if successful

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
EN_SIP_RESULT SipTxnHiSfSendCancel
(
    IN SS_UINT32         ulCanceledTxnObjId,
    IN SS_UINT32         ulCanceledTuObjId,
    IN SS_UINT32         ulTuObjId,
    IN SipDataUnitS     *pstSipSdu,
    IN SipTxnHiAuxDataS *pstAuxData,
    IO SS_UINT32        *pulTxnObjId
);


/*******************************************************************************
 Function   : SipTxnHiSfSendRsp

 Description: This API will be invoked by the TU component to send a response to
              network in stateful manner

 Input      : ulTxnObjId - The Id of the transaction object which passed the
                           request to the TU.  If the response being sent is 2xx
                           for INVITE, and if sending of this 2xx is not
                           successful, the fail result for this response will be
                           indicated using stateless interface
                           pFnSipTxnHiSlMsgSendResultInd, in which case this
                           ulTxnObjId can be used as timestamp by the TU.
              ulTuObjId  - The object of the TU which corresponds to this
                           response
              pstSipSdu  - Pointer to the SIP Stack data Unit, contains resonse
                           message, this param can not be NULL
              pstAuxData - Aux Data of the stack, for future extension

 Output     : None

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
EN_SIP_RESULT SipTxnHiSfSendRsp
(
    IN SS_UINT32         ulTxnObjId,
    IN SS_UINT32         ulTuObjId,
    IN SipDataUnitS     *pstSipSdu,
    IN SipTxnHiAuxDataS *pstAuxData
);


/*******************************************************************************
 Function   : SipTxnHiSlSendReq

 Description: This API will be invoked by the TU component to send a request
              message to network in stateless manner, bypassing the transaction
              component, this API is used by TU to send ACK for INVITE

 Input      : ulTuObjId  - The object of the TU which corresponds to this
                           request
              ulTuObjTimeStamp - The timestamp of the TU object
              pstSipSdu    - Pointer to the SIP Stack data Unit, contains
                             the request message, this param can not be NULL
              pstTptNwInfo - Transport Network information, contains source
                             address and Destination address, this parameter can
                             not be NULL.
              pstAuxData - Aux Data of the stack, for future extension

 Output     : pbProtocolSwitched - TRUE If protocol is switched from UDP to TCP
                                   FALSE, if protocol is not switched, If this
                                   param is NULL, protocol will not be switched

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
EN_SIP_RESULT SipTxnHiSlSendReq
(
    IN SS_UINT32         ulTuObjId,
    IN SS_UINT32         ulTuObjTimeStamp,
    IN SipDataUnitS     *pstSipSdu,
    IN SipTptNwInfoS    *pstTptNwInfo,
    IN SipTxnHiAuxDataS *pstAuxData,
    IO SS_BOOL          *pbProtocolSwitched
);


/*******************************************************************************
 Function   : SipTxnHiSlSendRsp

 Description: This API will be invoked by the TU component to send a response
              message to network in stateless manner, bypassing the transaction
              component, this API is used to retransmit 2XX for INVITE.

 Input      : ulTuObjId  - The object of the TU which corresponds to this
                           response
              ulTuObjTimeStamp - The timestamp of the TU object
              pstSipSdu    - Pointer to the SIP Stack data Unit, contains
                             SipMsg, this param can not be NULL
              pstTptNwInfo - Transport Network information, contains source
                             address and Destination address, this param
                             can not be NULL
              pstAuxData   - Aux Data of the stack, for future extension

 Output     : None

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
EN_SIP_RESULT SipTxnHiSlSendRsp
(
    IN SS_UINT32         ulTuObjId,
    IN SS_UINT32         ulTuObjTimeStamp,
    IN SipDataUnitS     *pstSipSdu,
    IN SipTptNwInfoS    *pstTptNwInfo,
    IN SipTxnHiAuxDataS *pstAuxData
);


/*******************************************************************************
 Function   : SipTxnHiTerminateTxn

 Description: This API will be invoked by the TU component to request the
              transaction component to terminate a transaction. This API can be
              used to terminate any transaction (INVITE, Non-INVITE
              (include CANCEL), Client, Server), and in any state.

              The transaction can be terminated in four ways:  Forceful,
              Graceful, Forceful without CANCEL response and Graceful without
              CANCEL response

              In Forceful mode, the transaction object will be simply freed on
              receiving the request. If the INVITE transaction is being
              canceled, then transaction will check if there is any CANCEL
              corresponding to  INVITE is cached in transaction, and generates
              200 for CANCEL and indicates this 200 for CANCEL to TU, and then
              deletes the INVITE transaction.

              In Forceful without any indication to TU, If the INVITE
              transaction is being canceled, then transaction will check if
              there is any CANCEL corresponding to  INVITE is cached in
              transaction, and if available it will first delete the CANCEL
              transaction, then it will delete the INVITE transaction. And no
              response for CANCEL will be indicated to TU.

              In Graceful mode, when a client transaction gets the terminate
              request, a flag will be set and the response or timeouts of that
              transaction will not be intimated to TU. When a Server transaction
              gets the terminate request, a 487 response will be sent to the
              network and transaction is kept alive as per the server
              transaction lifetime.

              In Graceful without CANCEL response to TU, If the INVITE
              transaction is being terminated, then transaction will check if
              there is any CANCEL corresponding to  INVITE is cached in
              transaction, and if available it will first delete the CANCEL
              transaction, then it will call graceful terminate. And no response
              for CANCEL will be indicated to TU.

 Input      : ulTxnObjId - The Id of the transaction object which needs to be
                           terminated
              ulTuObjId  - The object of the TU which corresponds to this
                           request
              enTermMode - The destroy mode: Graceful, Forceful, or graceful
                           without CANCEL response, and forceful without CANCEL
                           response

 Output     : None

 Return     : SIP_RET_SUCCESS or Error Code indicating FAILURE
*******************************************************************************/
EN_SIP_RESULT SipTxnHiTerminateTxn
(
    IN SS_UINT32             ulTxnObjId,
    IN SS_UINT32             ulTuObjId,
    IN EN_SIP_TERMINATE_MODE enTermMode
);

#ifdef __cplusplus
}
#endif

#endif


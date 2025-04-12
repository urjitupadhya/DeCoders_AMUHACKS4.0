import { CallLog } from "../models/emergency-call-log.model.js"

const addCaller = async (req,res) => {
    try {
        const {callerInfo} = req.body
        const user = req.user
    
        const existedCallLog = await CallLog.find(user._id)
    
        if (existedCallLog) {
            existedCallLog.callerDetail.append(callerInfo)
            const newCallLog = await CallLog.find(existedCallLog._id)
    
            return res.json({
                message: newCallLog,
                success: true
            })
        }
    
        const callLog = await CallLog.create({
            userID: user._id,
            callerDetail: [callerInfo]
        })
    
        const createdCallLog = await CallLog.findById(callLog._id)
    
        return res.json({
            message: createdCallLog,
            success: true
        })
    } catch (error) {
        console.log(error)
        return
    }

}


export {addCaller}
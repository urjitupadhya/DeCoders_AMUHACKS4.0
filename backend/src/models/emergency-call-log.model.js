import mongoose from "mongoose";


const callLogSchema = new mongoose.Schema(
    {
        userID: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Users"
        },
        callerDetail: {
            type: Object,
            required: true
        },
        customMessage: {
            type: String
        }
    },{timestamps: true}
)



export const CallLog = mongoose.model("CallLog", callLogSchema)
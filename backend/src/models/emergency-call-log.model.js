import mongoose from "mongoose";


const callerInfoSchema = new mongoose.Schema(
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
    }
)



export const Caller = mongoose.model("Caller", callerInfoSchema)
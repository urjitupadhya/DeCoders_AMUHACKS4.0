import mongoose from "mongoose";


const locationSchema = new mongoose.Schema(
    {
        userID: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Users"            
        },
        location: {
            type: String,
            required: true
        },
        time: {
            type: Date,
            def: Date.now
        }
    }
)

export const Location = mongoose.model("Location", locationSchema)
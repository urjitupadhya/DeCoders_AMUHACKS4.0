import mongoose from "mongoose";


const trackingSchema = new mongoose.Schema(
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

export const TrackingLocation = mongoose.model("TrackingLocation", trackingSchema)
import mongoose from "mongoose";
import jwt from "jsonwebtoken"

const userSchema = new mongoose.Schema(
    {
        fullName: {
            type: String,
            required: true
        },
        email: {
            type: String,
            required: true
        },
        refreshToken: {
            type: String
        }
    },{timestamps: true}
)

userSchema.methods.generateAccessToken = function(){
    return jwt.sign(
        {
            _id: this._id,
            emailID: this.emailID,
            fullName: this.fullName
        },process.env.ACCESS_TOKEN_SECRET
    )
}


userSchema.methods.generateRefreshToken = function(){
    return jwt.sign(
        {
            _id: this._id,
        },process.env.REFRESH_TOKEN_SECRET
    )
}


export const User = mongoose.model("User",userSchema)
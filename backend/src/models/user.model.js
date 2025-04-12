import mongoose from "mongoose";
import jwt from "jsonwebtoken";
import bcrypt from "bcrypt";

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
        password: {
            type: String
        },
        refreshToken: {
            type: String
        }
    },{timestamps: true}
)

userSchema.pre("save",async function(next){
    if(this.isModified("password")){
        this.password = await bcrypt.hash(this.password, 6)
    next()
    }

    return next()
})

userSchema.methods.isPasswordCorrect = async function(password){
    return await bcrypt.compare(password,this.password)
}

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
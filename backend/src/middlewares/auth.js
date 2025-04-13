import { User } from "../models/user.model.js";
import jwt from "jsonwebtoken";


const verifyUserJWT = async (req,res,next) => {
    // const token = req.header("Authorization")?.replace("Bearer ", "")
    const {accessToken} = req.body

    console.log(accessToken)

    if (!accessToken) {
        return res.status(404).json({
            message: "There is no token available."
        })
    }

    const decodedToken = jwt.verify(accessToken,process.env.ACCESS_TOKEN_SECRET)

    const user = await User.findById(decodedToken?._id).select("-password -refreshToken")
    if (!user) {
        return res.status(409).json({
            message: "Your token is invalid."
        })
    }


    req.user = user
    next()
}


export {verifyUserJWT}
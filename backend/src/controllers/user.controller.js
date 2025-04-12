import { User } from "../models/user.model.js";


const generateAccessAndRefreshToken = async (userId) => {
    try {
      const user = await User.findById(userId);
    
      const accessToken = user.generateAccessToken();
      const refreshToken = user.generateRefreshToken();
    
      user.refreshToken = refreshToken;
      await user.save({ validateBeforeSave: false });
    } catch (error) {
      console.log("Error while regenerate refersh tokens",error)
    }
    return { accessToken, refreshToken };
  };



const googleLogin = async (req, res) => {
    const { fullName, email } = req.body;
  
    if (!fullName) {
      return res.json({
        success: false,
        message: "Please enter your Fullname.",
      });
    }
  
    if (!email) {
      return res.json({
        success: false,
        message: "Please enter your valid email.",
      });
    }
  
    try {
      const existedUser = await User.find({ email }).select(
        "-password -refreshToken"
      );
    
      if (existedUser[0]) {
        const { accessToken, refreshToken } = await generateAccessAndRefreshToken(
          existedUser[0]?._id
        );
  
  
        return res
          .setHeader("accessToken", accessToken)
          .setHeader("refreshToken", refreshToken, refreshTokenOptions)
          .json({
            success: true,
            message: "User already existed.",
          });
      }
    } catch (error) {
      console.log("Error while finding existing user", error)
    }
  
    try {
      const user = await User.create({
        fullName,
        email
      });
    
      const { accessToken, refreshToken } = await generateAccessAndRefreshToken(
        user._id
      );
    
      const createdUser = await User.findById(user._id).select(
        "-refreshToken"
      );
    
      if (!createdUser) {
        return res.json({
          success: false,
          message: "Something went wrong in database call. Please try again. ",
        });
      }
    } catch (error) {
      console.log("Error while creating new user", error)
    }
  
    return res
      .setHeader("accessToken", accessToken)
      .setHeader("refreshToken", refreshToken)
      .json({
        success: true,
        message: "User created successfully."
      });
  }
  
export {googleLogin}
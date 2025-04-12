import { User } from "../models/user.model.js";


const generateAccessAndRefreshToken = async (userId) => {
    try {
      const user = await User.findById(userId);
    
      const accessToken = user.generateAccessToken();
      const refreshToken = user.generateRefreshToken();
    
      user.refreshToken = refreshToken;
      await user.save({ validateBeforeSave: false });
      return { accessToken, refreshToken }
    } catch (error) {
      console.log("Error while regenerate refersh tokens",error)
      return
    }
  };



const googleLogin = async (req, res) => {
    try {
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
      
          const existedUser = await User.find({ email }).select(
            "-password -refreshToken"
          );
        
          if (existedUser[0]) {
            const { accessToken, refreshToken } = await generateAccessAndRefreshToken(
              existedUser[0]?._id
            );
      
      
            return res
              .setHeader("accessToken", accessToken)
              .setHeader("refreshToken", refreshToken)
              .json({
                success: true,
                message: "User already existed.",
              });
          }
        
      
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
      
        return res
          .setHeader("accessToken", accessToken)
          .setHeader("refreshToken", refreshToken)
          .json({
            success: true,
            message: "User created successfully."
          });
    
    } catch (error) {
        console.log(error)
        return
    }
    
  }
  
export {googleLogin}
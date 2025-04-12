import mongoose, { mongo } from "mongoose";


async function dbconnect() {
    try {
        const connectInfo = await mongoose.connect(`${process.env.MONGO_URL}`)
        console.log("Database connected")
        
    } catch (error) {
        console.log(error)
        process.exit(1)
    }
}

export default dbconnect
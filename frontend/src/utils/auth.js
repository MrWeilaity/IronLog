// 获取当前用户ID
export function getCurrentUserId() {
    try {
        const userStr = localStorage.getItem('user')
        if (userStr) {
            const user = JSON.parse(userStr)
            return user.id || 1 // 默认返回1
        }
    } catch (err) {
        console.error('Failed to get user ID', err)
    }
    return 1 // 默认用户ID
}

// 获取当前用户信息
export function getCurrentUser() {
    try {
        const userStr = localStorage.getItem('user')
        if (userStr) {
            return JSON.parse(userStr)
        }
    } catch (err) {
        console.error('Failed to get user info', err)
    }
    return null
}

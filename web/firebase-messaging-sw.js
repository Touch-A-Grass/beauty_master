importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

const firebaseConfig = {
  apiKey: "AIzaSyBCS9JtBZlbqncab8B_vqdAp_Dc61Ik0jk",
  authDomain: "beatymaster-82227.firebaseapp.com",
  projectId: "beatymaster-82227",
  storageBucket: "beatymaster-82227.firebasestorage.app",
  messagingSenderId: "783770945837",
  appId: "1:783770945837:web:b3808b83de6ec356cb2ba4",
  measurementId: "G-KVR0YS1M2B"
};

firebase.initializeApp(firebaseConfig);

const messaging = firebase.messaging();
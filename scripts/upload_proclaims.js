const admin = require('firebase-admin');
const serviceAccount = require('./hana-tongdok-4887a-firebase-adminsdk-z0lo7-8d2bb7c780.json');

// Firebase 초기화
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const firestore = admin.firestore();

// 데이터 추가 함수
async function addData() {
  const collectionRef = firestore.collection('proclaims'); // Firestore 컬렉션 이름으로 변경

  // 1에서 41까지의 데이터 추가
  for (let i = 1; i <= 41; i++) {
    const data = {
      book: 'book1',
      page: i,
      id: i.toString(),
    };

    // Firestore에 데이터 추가
    await collectionRef.add(data);
    console.log(`Data added: ${JSON.stringify(data)}`);
  }

  console.log('Data addition complete!');
}

async function updatePageFieldType() {
  const collectionRef = firestore.collection('proclaims'); // Firestore 컬렉션 이름으로 변경

  // Get all documents in the collection
  const snapshot = await collectionRef.get();

  // Update each document
  snapshot.forEach(async (doc) => {
    const data = doc.data();

    // Convert 'page' field to a number
    data.id = String(data.id);
    data.page = Number(data.page);

    // Update the document
    await collectionRef.doc(doc.id).update(data);

    console.log(`Updated document ${doc.id}: ${JSON.stringify(data)}`);
  });

  console.log('Update complete!');
}


// 데이터 추가 함수 호출
addData()
  .then(() => process.exit())
  .catch((error) => {
    console.error('Error adding data: ', error);
    process.exit(1);
  });

// Call the function to update the page field type
// updatePageFieldType()
//   .then(() => process.exit())
//   .catch((error) => {
//     console.error('Error updating page field type: ', error);
//     process.exit(1);
//   });
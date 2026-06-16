const moduloAdmin = 'firebase' + String.fromCharCode(45) + 'admin';
const admin = require(moduloAdmin);
const credenciais = require('./chaves_acesso.json');

admin.initializeApp({
    credential: admin.credential.cert(credenciais)
});

async function criarGestoresEmLote() {
    const novosGestores = [
        { email: 'gestor1@eurofarma.com', password: 'Euro@2026', name: 'Lucas Almeida' },
        { email: 'gestor2@eurofarma.com', password: 'Euro@2026', name: 'Bruno Costa' },
        { email: 'gestor3@eurofarma.com', password: 'Euro@2026', name: 'Rafael Souza' }
    ];

    for (const g of novosGestores) {
        try {
            const userRecord = await admin.auth().createUser({
                email: g.email,
                password: g.password,
                emailVerified: true,
                displayName: g.name
            });

            await admin.firestore().collection('users').doc(userRecord.uid).set({
                email: g.email,
                name: g.name,
                role: 'Gestor'
            });

            console.log('Sucesso ao criar ' + g.email + ' com UID: ' + userRecord.uid);
        } catch (error) {
            console.error('Falha ao criar o usuário ' + g.email + ':', error);
        }
    }
}

criarGestoresEmLote();